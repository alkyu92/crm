class TasksController < ApplicationController
  before_action :find_opportunity
  before_action :find_task, only: [:update, :destroy, :update_task_status]

  def create
    @task = @opportunity.tasks.build(params_task)

    if @task.save

      @opportunity.timelines.create!(tactivity: "task",
      idactivity: @task.id, action: "created", user_id: current_user.id)

      flash[:success] = "Task Log added!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to add task log!"
      redirect_to request.referrer
    end
  end

  def update
    if @task.update(params_task)
      @opportunity.timelines.create!(tactivity: "task",
      idactivity: @task.id, action: "updated", user_id: current_user.id)
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
    idactivity: @task.id, action: "deleted", user_id: current_user.id)
    flash[:success] = "Task log deleted!"
    redirect_to request.referrer
  end

  def update_task_status
    if @task.complete == true
      @task.update_attributes(complete: false)
    else
      @task.update_attributes(complete: true)
    end
    @opportunity.timelines.create!(tactivity: "task",
    idactivity: @task.id, action: "updated status", user_id: current_user.id)
    flash[:success] = "Task log updated!"
    redirect_to request.referrer
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
