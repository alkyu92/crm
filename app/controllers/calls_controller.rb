class CallsController < ApplicationController
  before_action :find_opportunity
  before_action :find_call, only: [:update, :destroy, :update_call_status]

  def create
    @call = @opportunity.calls.build(params_call)

    if @call.save
      @opportunity.timelines.create!(tactivity: "call log",
      idactivity: @call.id, action: "created", user_id: current_user.id)
      flash[:success] = "Call Log added!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to add call log!"
      redirect_to request.referrer
    end
  end

  def update
    if @call.update(params_call)
      @opportunity.timelines.create!(tactivity: "call log",
      idactivity: @call.id, action: "updated", user_id: current_user.id)
      flash[:success] = "Call entry updated!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to update call entry!"
      redirect_to request.referrer
    end
  end

  def destroy
    @call.destroy
    @opportunity.timelines.create!(tactivity: "call log",
    idactivity: @call.id, action: "deleted", user_id: current_user.id)
    flash[:success] = "Call log deleted!"
    redirect_to request.referrer
  end

  def update_call_status
    if @call.complete == true
      @call.update_attributes(complete: false)
    else
      @call.update_attributes(complete: true)
    end
    @opportunity.timelines.create!(tactivity: "call log",
    idactivity: @call.id, action: "updated status", user_id: current_user.id)
    flash[:success] = "Call log updated!"
    redirect_to request.referrer
  end

  private
  def params_call
    params.require(:call).permit(:description, :call_datetime, :duration)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def find_call
    @call = Call.find(params[:id])
  end
end
