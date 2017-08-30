class TasksController < ApplicationController
  before_action :find_task, only: [:edit, :update, :destroy, :update_task_status]

  def index
    # for AJAX timelines
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]

    @tasks = Task.all.includes(:opportunity).order('due_date').page(params[:page]).per(10)
  end

  def show
    # for AJAX timelines
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
  end

  def create
    @opportunity = Opportunity.find(params[:opportunity_id])
    @subject = @opportunity

    @task = @opportunity.tasks.build(params_task)
    @task.user_id = current_user.id

    respond_to do |format|
      if @task.save
        timeline_task("created task")
        format.js { flash.now[:success] = "Task log added!" }
      else
        format.js { flash.now[:danger] = "Failed to add task log!" }
      end
    end

  end

  def edit

  end

  def update
    # for Ajax timelines
    @subject = Opportunity.find(params[:opportunity_id])

      if @task.update(params_task)

        if params[:completed]
          if @task.complete == true
            @task.update_attributes(complete: false)
          else
            @task.update_attributes(complete: true)
          end
        end

        timeline_task("updated task")
        flash[:success] = "Task updated!"
        redirect_to opportunity_path(@opportunity, anchor: "task-#{@task.id}")
      else
        flash[:danger] = "Failed to update task!"
        redirect_to opportunity_path(@opportunity, anchor: "task-#{@task.id}")
      end

  end

  def destroy
    # for AJAX timelines
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]

    @task.destroy
    timeline_task("deleted task")
    respond_to do |format|
      format.js { flash.now[:success] = "Task log deleted!" }
    end
  end

  def update_task_status
    # for AJAX timelines
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]

    respond_to do |format|
    if @task.complete == true
      @task.update_attributes(complete: false)
      status = "updated task status from Completed to Incomplete for task "
      timeline_task(status)
      format.js { flash.now[:success] = status.capitalize + @task.description.truncate(50) }
    else
      @task.update_attributes(complete: true)
      status = "updated task status from Incomplete to Completed for task "
      timeline_task(status)
      format.js { flash.now[:success] = status.capitalize + @task.description.truncate(50) }
    end
    end
  end

  private

  def timeline_task(action)
    @opportunity.timelines.create!(
    tactivity: "task-" + @task.id.to_s,
    nactivity: @task.description.truncate(50),
    action: action,
    user_id: current_user.id
    )
  end

  def params_task
    params.require(:task).permit(:description, :due_date)
  end

  def find_task
    @opportunity = Opportunity.find(params[:opportunity_id])
    @task = @opportunity.tasks.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
