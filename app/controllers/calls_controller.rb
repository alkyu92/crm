class CallsController < ApplicationController
  before_action :find_opportunity
  before_action :find_call, only: [:destroy, :update_call_status]

  def create
    @call = @opportunity.calls.build(params_call)

    if @call.save
      flash[:success] = "Call Log added!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to add call log!"
      redirect_to request.referrer
    end
  end

  def destroy
    @call.destroy
    flash[:success] = "Call log deleted!"
    redirect_to request.referrer
  end

  def update_call_status
    if @call.complete == true
      @call.update_attributes(complete: false)
    else
      @call.update_attributes(complete: true)
    end

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
    find_opportunity
    @call = Call.find(params[:id])
  end
end
