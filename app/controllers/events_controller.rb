class EventsController < ApplicationController
  before_action :find_opportunity
  before_action :find_event, only: [:destroy, :update_event_status]

  def create
    @event = @opportunity.events.build(params_event)

    if @event.save
      flash[:success] = "Event Log added!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to add event log!"
      redirect_to request.referrer
    end
  end

  def destroy
    @event.destroy
    flash[:success] = "Event log deleted!"
    redirect_to request.referrer
  end

  def update_event_status
    if @event.complete == true
      @event.update_attributes(complete: false)
    else
      @event.update_attributes(complete: true)
    end

    flash[:success] = "Event log updated!"
    redirect_to request.referrer
  end

  private
  def params_event
    params.require(:event).permit(:description, :event_date)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def find_event
    find_opportunity
    @event = Event.find(params[:id])
  end
end
