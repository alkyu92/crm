class CallsController < ApplicationController
  before_action :find_opportunity
  before_action :find_call, only: [:update, :destroy, :update_call_status]

  def create
    @call = @opportunity.calls.build(params_call)

    if @call.save
      @opportunity.timelines.create!(tactivity: "call log",
      nactivity: @call.description, action: "created call log", user_id: current_user.id)

      flash[:success] = "Call Log created!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to create call log!"
      redirect_to request.referrer
    end
  end

  def update
    if @call.update(params_call)
      @opportunity.timelines.create!(tactivity: "call log",
      nactivity: @call.description, action: "updated call log", user_id: current_user.id)

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
    nactivity: @call.description, action: "deleted call log", user_id: current_user.id)
    flash[:success] = "Call log deleted!"
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
