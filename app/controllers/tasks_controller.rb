class TasksController < ApplicationController
  before_action :find_opportunity
  before_action :find_task, only: [:update, :destroy, :update_task_status]

  def create
    @task = @opportunity.tasks.build(params_task)

    respond_to do |format|
      if @task.save

        @opportunity.timelines.create!(tactivity: "task",
        nactivity: @task.description, action: "created task", user_id: current_user.id)

        # flash[:success] = "Task Log added!"
        # redirect_to request.referrer

        format.js

      else
        # flash[:danger] = "Failed to add task log!"
        # redirect_to request.referrer
      end
    end

  end

  def update
    if @task.update(params_task)
      @opportunity.timelines.create!(tactivity: "task",
      nactivity: @task.description, action: "updated task", user_id: current_user.id)
      flash[:success] = "Task updated!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to update task!"
      redirect_to request.referrer
    end
  end

  def destroy
    @task.destroy
    @opportunity.timelines.create!(tactivity: "task",
    nactivity: @task.description, action: "deleted task", user_id: current_user.id)
    # flash[:success] = "Task log deleted!"
    # redirect_to request.referrer
    respond_to do |format|
      format.js
    end
  end

  def update_task_status
    if @task.complete == true
      @task.update_attributes(complete: false)
      @opportunity.timelines.create!(tactivity: "task",
      nactivity: @task.description,
      action: "updated task status from Completed to Incomplete for task", user_id: current_user.id)
    else
      @task.update_attributes(complete: true)
      @opportunity.timelines.create!(tactivity: "task",
      nactivity: @task.description,
      action: "updated task status from Incomplete to Completed for task", user_id: current_user.id)
    end

    respond_to do |format|
      format.js
    end
    # flash[:success] = "Task log status updated!"
    # redirect_to request.referrer
  end

  private
  def params_task
    params.require(:task).permit(:description, :due_date)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Record not found!"
    redirect_to opportunities_path
  end

  def find_task
    @task = Task.find(params[:id])
  end
end
