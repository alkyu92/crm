class TasksController < ApplicationController
  before_action :find_opportunity, except: :index
  before_action :find_task, only: [:update, :destroy, :update_task_status]

  def index
    @tasks = Task.all.order('due_date')
  end

  def create
    @task = @opportunity.tasks.build(params_task)

    respond_to do |format|
      if @task.save
        @opportunity.timelines.create!(tactivity: "task",
        nactivity: @task.description, action: "created task", user_id: current_user.id)
        format.js { flash.now[:success] = "Task log added!" }
      else
        format.js { flash.now[:danger] = "Failed to add task log!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @task.update(params_task)

        @opportunity.timelines.create!(tactivity: "task",
        nactivity: @task.description, action: "updated task", user_id: current_user.id)
        format.js { flash.now[:success] = "Task updated!" }
        #
        # redirect_to request.referrer
      else
        format.js { flash.now[:danger] = "Failed to update task!" }
        #
        # redirect_to request.referrer
      end
    end

  end

  def destroy
    @task.destroy
    @opportunity.timelines.create!(tactivity: "task",
    nactivity: @task.description, action: "deleted task", user_id: current_user.id)
    respond_to do |format|
      format.js { flash.now[:success] = "Task log deleted!" }
    end
  end

  def update_task_status
    respond_to do |format|
    if @task.complete == true
      @task.update_attributes(complete: false)
      @opportunity.timelines.create!(tactivity: "task",
      nactivity: @task.description,
      action: "updated task status from Completed to Incomplete for task", user_id: current_user.id)
      format.js { flash.now[:success] = "Task log status updated from Completed to Incomplete!" }
    else
      @task.update_attributes(complete: true)
      @opportunity.timelines.create!(tactivity: "task",
      nactivity: @task.description,
      action: "updated task status from Incomplete to Completed for task", user_id: current_user.id)
      format.js { flash.now[:success] = "Task log status updated from Incomplete to Completed!" }
    end
    end
  end

  private
  def params_task
    params.require(:task).permit(:description, :due_date)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Record not found!"
    redirect_to opportunities_path
  end

  def find_task
    @task = Task.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
