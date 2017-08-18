class TasksController < ApplicationController
  before_action :find_opportunity, except: :index
  before_action :find_task, only: [:update, :destroy, :update_task_status]

  def index
    @tasks = Task.all.includes(:opportunity).order('due_date').page(params[:page]).per(10)

    if params[:opportunity_id]
    @opportunity = Opportunity.find(params[:opportunity_id])
    respond_to do |format|
      format.js
    end
  end

  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def create
    @task = @opportunity.tasks.build(params_task)

    respond_to do |format|
      if @task.save
        timeline_task("created task")
        format.js { flash.now[:success] = "Task log added!" }
      else
        format.js { flash.now[:danger] = "Failed to add task log!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @task.update(params_task)
        timeline_task("updated task")
        format.js { flash.now[:success] = "Task updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update task!" }
      end
    end

  end

  def destroy
    @task.destroy
    timeline_task("deleted task")
    respond_to do |format|
      format.js { flash.now[:success] = "Task log deleted!" }
    end
  end

  def update_task_status
    respond_to do |format|
    if @task.complete == true
      @task.update_attributes(complete: false)
      status = "updated task status from Completed to Incomplete for task "
      timeline_task(status)
      format.js { flash.now[:success] = status.capitalize + @task.description }
    else
      @task.update_attributes(complete: true)
      status = "updated task status from Incomplete to Completed for task "
      timeline_task(status)
      format.js { flash.now[:success] = status.capitalize + @task.description }
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
