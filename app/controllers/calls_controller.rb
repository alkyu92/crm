class CallsController < ApplicationController
  before_action :find_subject
  before_action :find_call, only: [:edit, :update, :destroy]

  def index
    @calls = Call.includes(:user, :opportunity).page(params[:page]).per(10)

    # AJAX
    @opportunity = Opportunity.find_by_id(session[:op_id])
    @opcall = @opportunity.calls.includes(
    :user).page(params[:call_page]).per(10) if @opportunity
  end

  def create
    @call = @subject.calls.build(params_call)
    @call.user_id = current_user.id

    respond_to do |format|
      if @call.save
        timeline_call("created call log")
        format.js { flash.now[:success] = "Call log created!" }
      else
        format.js { flash.now[:danger] = "Failed to create call log!" }
      end
    end

    # AJAX
    session[:op_id] = @call.opportunity.id
    @opportunity = Opportunity.find(@call.opportunity)
    @opcall = @opportunity.calls.includes(:user).page(params[:call_page]).per(10)
  end

  def edit
  end

  def update
      if @call.update(params_call)
        timeline_call("updated call log")
        flash[:success] = "Call entry updated!"
        redirect_to opportunity_path(@opportunity, anchor: "call-callInfo-#{@call.id}")
      else
        flash[:danger] = "Failed to update call entry!"
        redirect_to opportunity_path(@opportunity, anchor: "call-callInfo-#{@call.id}")
      end

  end

  def destroy
    # AJAX
    @opportunity = Opportunity.find_by_id(@call.opportunity.id)
    @opcall = @opportunity.calls.includes(:user).page(params[:task_page]).per(10)

    @call.destroy
    timeline_call("deleted call log")

    respond_to do |format|
      format.html { redirect_to opportunity_path(@opportunity, anchor: "call") }
      format.js
    end

    # AJAX
    @calls = Call.includes(:opportunity).page(params[:page]).per(10)
  end

  private

  def timeline_call(action)
    @opportunity.timelines.create!(
    tactivity: "call-" + @call.id.to_s,
    nactivity: @call.description.truncate(50),
    action: action,
    user_id: current_user.id
    )
  end

  def params_call
    params.require(:call).permit(:description, :call_datetime, :duration)
  end

  def find_subject
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
    @opportunity = @subject

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
