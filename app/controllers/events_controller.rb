class EventsController < ApplicationController
  before_action :find_opportunity
  before_action :find_event, only: [:update, :destroy, :update_event_status]

  def create
    @event = @opportunity.events.build(params_event)

    respond_to do |format|
      if @event.save
        @opportunity.timelines.create!(tactivity: "event",
        nactivity: @event.description, action: "created event", user_id: current_user.id)
        format.js { flash.now[:success] = "Event log created!" }
      else
        format.js { flash.now[:success] = "Failed to create event log!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @event.update(params_event)
        @opportunity.timelines.create!(tactivity: "event",
        nactivity: @event.description, action: "updated event", user_id: current_user.id)
        format.js { flash.now[:success] = "Event entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update event entry!" }
      end
    end
  end

  def destroy
    @event.destroy

    @opportunity.timelines.create!(tactivity: "event",
    nactivity: @event.description, action: "deleted event", user_id: current_user.id)

    respond_to do |format|
      format.js { flash.now[:success] = "Event log deleted!" }
    end
  end

  def update_event_status

    respond_to do |format|
      if @event.complete == true
        @event.update_attributes(complete: false)

        @opportunity.timelines.create!(tactivity: "event",
        nactivity: @event.description,
        action: "updated event status from Attended to Not Attend for event", user_id: current_user.id)
        format.js { flash.now[:success] = "Event status changed from Attended to Not Attend!" }
      else
        @event.update_attributes(complete: true)
        @opportunity.timelines.create!(tactivity: "event",
        nactivity: @event.description,
        action: "updated event status from Not Attend to Attended for event", user_id: current_user.id)
        format.js { flash.now[:success] = "Event status changed from Not Attend to Attended!" }
      end
    end
  end

  private
  def params_event
    params.require(:event).permit(:description, :event_date)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_event
    @event = Event.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
