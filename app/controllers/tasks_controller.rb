class TasksController < ApplicationController
  before_action :find_opportunity
  before_action :find_task, only: [:destroy, :update_task_status]

  def create
    @task = @opportunity.tasks.build(params_task)

    if @task.save
      flash[:success] = "Task Log added!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to add task log!"
      redirect_to request.referrer
    end
  end

  def destroy
    @task.destroy
    flash[:success] = "Task log deleted!"
    redirect_to request.referrer
  end

  def update_task_status
    if @task.complete == true
      @task.update_attributes(complete: false)
    else
      @task.update_attributes(complete: true)
    end

    flash[:success] = "Task log updated!"
    redirect_to request.referrer
  end

  private
  def params_task
    params.require(:task).permit(:description, :due_date)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def find_task
    find_opportunity
    @task = Task.find(params[:id])
  end
end
