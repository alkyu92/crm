class CallsController < ApplicationController
  before_action :find_subject
  before_action :find_call, only: [:edit, :update, :destroy]

  def index
    @calls = Call.page(params[:page]).per(10)
    # @calls = []

    # AJAX
    # @subject = Opportunity.find_by_id(session[:op_id])
    # @opcall = @subject.calls.includes(
    # :user).page(params[:call_page]).per(10) if @subject
  end

  def create
    @call = @subject.calls.build(params_call)
    @call.user_id = current_user.id

    respond_to do |format|
      if @call.save
        # timeline
        @calltimeline = @subject.timelines.create!(
        action: "#{current_user.name} created call log <strong>#{@call.description}</strong>",
        user_id: current_user.id
        )
        format.js { flash.now[:success] = "Call log created!" }
      else
        format.js { flash.now[:danger] = "Failed to create call log!" }
      end
    end

    # AJAX
    session[:op_id] = @call.polycall.id

    @subject = Opportunity.find(@call.polycall) if params[:opportunity_id]
    @subject = Marketing.find(@call.polycall) if params[:marketing_id]
    @subject = Case.find(@call.polycall) if params[:case_id]

    @opcall = @subject.calls.includes(:user).page(params[:call_page]).per(10)
  end

  def edit
  end

  def update
    @old_description = @call.description
    @old_duration = @call.duration
    @old_date = @call.call_datetime.strftime('%d %b %Y %H:%M')

      if @call.update(params_call)

        save_timeline_if_any_changes

        flash[:success] = "Call entry updated!"
        redirect_to polymorphic_path(@subject, anchor: "call-callInfo-#{@call.id}")
      else
        flash[:danger] = "Failed to update call entry!"
        redirect_to polymorphic_path(@subject, anchor: "call-callInfo-#{@call.id}")
      end

  end

  def destroy
    # AJAX
    @subject = Opportunity.find_by_id(@call.polycall.id) if params[:opportunity_id]
    @subject = Marketing.find_by_id(@call.polycall.id) if params[:marketing_id]
    @subject = Case.find_by_id(@call.polycall.id) if params[:case_id]

    @opcall = @subject.calls.includes(:user).page(params[:task_page]).per(10)

    # timeline
    @calltimeline = @subject.timelines.create!(
    action: "#{current_user.name} deleted call log
    <strong>#{@call.description.truncate(50)}</strong>",
    user_id: current_user.id
    )
    @call.destroy


    respond_to do |format|
      format.html { redirect_to polymorphic_path(@subject, anchor: "call") }
      format.js { flash[:success] = "Call log deleted!" }
    end

    # AJAX
    @calls = Call.includes(:user, :subject).page(params[:page]).per(10)
  end

  private

  def timeline_call(param, old, latest)
    @calltimeline = @subject.timelines.create!(
    action: "#{current_user.name} updated call log <strong>#{param}</strong> from
    <strong>#{old}</strong> to <strong>#{latest}</strong>",
    user_id: current_user.id
    )
  end

  def save_timeline_if_any_changes
    if @call.description_previously_changed?
      timeline_call("description", @old_description, @call.description)
    end
    if @call.duration_previously_changed?
      timeline_call("duration", @old_duration, @call.duration)
    end
    if @call.call_datetime_previously_changed?
      timeline_call("datetime", @old_date, @call.call_datetime.strftime('%d %b %Y %H:%M'))
    end
  end

  def params_call
    params.require(:call).permit(:description, :call_datetime, :duration)
  end

  def find_subject
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
    @subject = Case.find(params[:case_id]) if params[:case_id]
    @subject = Marketing.find(params[:marketing_id]) if params[:marketing_id]

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_call
    find_subject
    @call = @subject.calls.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
