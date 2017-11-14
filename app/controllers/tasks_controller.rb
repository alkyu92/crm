class TasksController < ApplicationController
  before_action :find_subject
  before_action :find_task, only: [:show, :edit, :update, :destroy, :update_task_status]

  def index
    @tasks = Task.order('due_date').page(params[:page]).per(10)
    # @tasks = []

    # AJAX
    # @subject = Opportunity.find_by_id(session[:op_id])
    # @optask = @subject.tasks.includes(:user).order(
    # 'due_date').page(params[:task_page]).per(10) if @subject
  end

  def show
  end

  def create
    @task = @subject.tasks.build(params_task)
    @task.user_id = current_user.id

    respond_to do |format|
      if @task.save
        # timeline
        @tasktimeline = @subject.timelines.create!(
        action: "#{current_user.name} created task
        <strong>#{@task.description.truncate(50)}</strong>",
        user_id: current_user.id
        )
        format.js { flash.now[:success] = "Task log added!" }
      else
        format.js { flash.now[:danger] = "Failed to add task log!" }
      end
    end

    # AJAX
    # session[:op_id] = @task.polytask.id
    @subject = Opportunity.find(@task.polytask) if params[:opportunity_id]
    @subject = Marketing.find(@task.polytask) if params[:marketing_id]
    @subject = Case.find(@task.polytask) if params[:case_id]

    @optask = @subject.tasks.includes(:user).order(
    'due_date').page(params[:task_page]).per(10)

  end

  def edit

  end

  def update
    @old_description = @task.description.truncate(50)
    @old_date = @task.due_date.strftime('%d %b %Y %H:%M')
    @old_status = @task.complete

      if @task.update(params_task)

        if params[:completed]
          if @task.complete == true
            @task.update_attributes(complete: false)
          else
            @task.update_attributes(complete: true)
          end
        end

        # timeline
        save_timeline_if_any_changes

        flash[:success] = "Task updated!"
        redirect_to polymorphic_path(@subject, anchor: "task-taskInfo-#{@task.id}")
      else
        flash[:danger] = "Failed to update task!"
        redirect_to polymorphic_path(@subject, anchor: "task-taskInfo-#{@task.id}")
      end

  end

  def destroy
    # AJAX
    # @subject = Opportunity.find_by_id(@task.polytask.id)
    # @optask = @subject.tasks.includes(:user).order(
    # 'due_date').page(params[:task_page]).per(10) if @subject

    @task.destroy
    # timeline
    @tasktimeline = @subject.timelines.create!(
    action: "#{current_user.name} deleted task
    <strong>#{@task.description.truncate(50)}</strong>",
    user_id: current_user.id
    )
    respond_to do |format|
      format.html { redirect_to polymorphic_path(@subject, anchor: "task") }
      format.js { flash[:success] = "Task deleted!" }
    end

    # AJAX
    @tasks = Task.includes(:user, :subject).order('due_date').page(params[:page]).per(10)
  end

  def update_task_status
    respond_to do |format|
    if @task.complete == true
      @task.update_attributes(complete: false)
      # timeline
      @tasktimeline = @subject.timelines.create!(
      action: "#{current_user.name} updated task status from <strong>Completed</strong>
      to <strong>Incomplete</strong> for task #{@task.description.truncate(50)}",
      user_id: current_user.id
      )
      format.js { flash.now[:success] = status.capitalize + @task.description.truncate(50) }
    else
      @task.update_attributes(complete: true)
      # timeline
      @tasktimeline = @subject.timelines.create!(
      action: "#{current_user.name} updated task status from <strong>Incomplete</strong>
      to <strong>Completed</strong> for task #{@task.description.truncate(50)}",
      user_id: current_user.id
      )
      format.js { flash.now[:success] = status.capitalize + @task.description.truncate(50) }
    end
    end
  end

  private

  def timeline_task(param, old, latest)
    # timeline
    @tasktimeline = @subject.timelines.create!(
    action: "#{current_user.name} updated task <strong>#{param}</strong> from
    <strong>#{old}</strong> to <strong>#{latest}</strong>",
    user_id: current_user.id
    )
  end

  def save_timeline_if_any_changes
    if @task.description_previously_changed?
      timeline_task("description", @old_description, @task.description.truncate(50))
    end
    if @task.due_date_previously_changed?
      timeline_task("due_date", @old_date, @task.due_date.strftime('%d %b %Y %H:%M'))
    end
    if @task.complete_previously_changed?
      timeline_task("status", @old_status, @task.complete)
    end
  end

  def params_task
    params.require(:task).permit(:description, :due_date)
  end

  def find_task
    find_subject
    @task = @subject.tasks.find(params[:id])
  end

  def find_subject
    # for AJAX timelines
      @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
      @subject = Marketing.find(params[:marketing_id]) if params[:marketing_id]
      @subject = Case.find(params[:case_id]) if params[:case_id]
  end

end
