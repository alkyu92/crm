class TasksController < ApplicationController
  before_action :find_subject
  before_action :find_task, only: [:show, :edit, :update, :destroy, :update_task_status]

  def index
    @tasks = Task.includes(:user, :opportunity).order('due_date').page(params[:page]).per(10)

    # AJAX
    # @opportunity = Opportunity.find(session[:op_id]) || nil
    # @optask = @opportunity.tasks.includes(:user).order('due_date').page(params[:task_page]).per(10) || nil

  end

  def show
  end

  def create
    @task = @subject.tasks.build(params_task)
    @task.user_id = current_user.id

    respond_to do |format|
      if @task.save
        timeline_task("created task")
        format.js { flash.now[:success] = "Task log added!" }
      else
        format.js { flash.now[:danger] = "Failed to add task log!" }
      end
    end

    # AJAX
    session[:op_id] = @task.opportunity.id
    @opportunity = Opportunity.find(@task.opportunity)
    @optask = @opportunity.tasks.includes(:user).order('due_date').page(params[:task_page]).per(10)

  end

  def edit

  end

  def update
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
        redirect_to opportunity_path(@opportunity, anchor: "task-taskInfo-#{@task.id}")
      else
        flash[:danger] = "Failed to update task!"
        redirect_to opportunity_path(@opportunity, anchor: "task-taskInfo-#{@task.id}")
      end

  end

  def destroy
    # AJAX
    @opportunity = Opportunity.find(session[:op_id])
    @optask = @opportunity.tasks.includes(:user).order('due_date').page(params[:task_page]).per(10)

    @tasks = Task.includes(:opportunity).order('due_date').page(params[:page]).per(10)
    @task.destroy
    timeline_task("deleted task")
    redirect_to opportunity_path(@opportunity, anchor: "task")

  end

  def update_task_status
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
    @subject.timelines.create!(
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
    find_subject
    @task = @subject.tasks.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_subject
    # for AJAX timelines
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
    @opportunity = @subject

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
