class EventsController < ApplicationController
  before_action :find_opportunity
  before_action :find_event, only: [:update, :destroy, :update_event_status]

  def create
    @event = @opportunity.events.build(params_event)

    respond_to do |format|
      if @event.save
        @opportunity.timelines.create!(tactivity: "event",
        nactivity: @event.description, action: "created event", user_id: current_user.id)

        format.js
        # flash[:success] = "Event Log added!"
        # redirect_to request.referrer
      else
        # flash[:danger] = "Failed to add event log!"
        # redirect_to request.referrer
      end
    end

  end

  def update
    if @event.update(params_event)
      @opportunity.timelines.create!(tactivity: "event",
      nactivity: @event.description, action: "updated event", user_id: current_user.id)

      flash[:success] = "Event entry created!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to create event entry!"
      redirect_to request.referrer
    end
  end

  def destroy
    @event.destroy

    @opportunity.timelines.create!(tactivity: "event",
    nactivity: @event.description, action: "deleted event", user_id: current_user.id)

    respond_to do |format|
      format.js
    end
    # flash[:success] = "Event log deleted!"
    # redirect_to request.referrer
  end

  def update_event_status
    if @event.complete == true
      @event.update_attributes(complete: false)

      @opportunity.timelines.create!(tactivity: "event",
      nactivity: @event.description,
      action: "updated event status from Attended to Not Attend for event", user_id: current_user.id)
    else
      @event.update_attributes(complete: true)
      @opportunity.timelines.create!(tactivity: "event",
      nactivity: @event.description,
      action: "updated event status from Not Attend to Attended for event", user_id: current_user.id)
    end

    respond_to do |format|
      format.js
    end
    # flash[:success] = "Event log updated!"
    # redirect_to request.referrer
  end

  private
  def params_event
    params.require(:event).permit(:description, :event_date)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def find_event
    @event = Event.find(params[:id])
  end
end
