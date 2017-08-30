class CallsController < ApplicationController
  before_action :find_call, only: [:edit, :update, :destroy, :update_call_status]

  def index
    # for AJAX timelines
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]

    @calls = Call.all.includes(:opportunity).page(params[:page]).per(10)
  end

  def show
    # for AJAX timelines
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
  end

  def create
    @opportunity = Opportunity.find(params[:opportunity_id])
    @subject = @opportunity

    @call = @opportunity.calls.build(params_call)
    @call.user_id = current_user.id

    respond_to do |format|
      if @call.save
        timeline_call("created call log")
        format.js { flash.now[:success] = "Call log created!" }
      else
        format.js { flash.now[:danger] = "Failed to create call log!" }
      end
    end

  end

  def edit

  end

  def update

      if @call.update(params_call)
        timeline_call("updated call log")
        flash[:success] = "Call entry updated!"
        redirect_to opportunity_path(@opportunity, anchor: "call-#{@call.id}")
      else
        flash[:danger] = "Failed to update call entry!"
        redirect_to opportunity_path(@opportunity, anchor: "call-#{@call.id}")
      end

  end

  def destroy
    # for AJAX timelines
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]

    @call.destroy
    timeline_call("deleted call log")
    respond_to do |format|
      format.js { flash.now[:success] = "Call log deleted!" }
    end
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

  def find_call
    @opportunity = Opportunity.find(params[:opportunity_id])
    @call = @opportunity.calls.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
