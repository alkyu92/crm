class EventsController < ApplicationController
  before_action :find_opportunity, except: :index
  before_action :find_event, only: [:update, :destroy, :update_event_status]

  def index
    @events = Event.all.includes(:opportunity).order('event_date').page(params[:page]).per(10)

    if params[:opportunity_id]
    @opportunity = Opportunity.find(params[:opportunity_id])
    respond_to do |format|
      format.js
    end
  end

  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def create
    @event = @opportunity.events.build(params_event)

    respond_to do |format|
      if @event.save
        timeline_event("created event")
        format.js { flash.now[:success] = "Event log created!" }
      else
        format.js { flash.now[:success] = "Failed to create event log!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @event.update(params_event)
        timeline_event("updated event")
        format.js { flash.now[:success] = "Event entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update event entry!" }
      end
    end
  end

  def destroy
    @event.destroy
    timeline_event("deleted event")
    respond_to do |format|
      format.js { flash.now[:success] = "Event log deleted!" }
    end
  end

  def update_event_status

    respond_to do |format|
      if @event.complete == true
        @event.update_attributes(complete: false)
        status = "updated event status from Attended to Not Attend for event"
        timeline_event(status)
        format.js { flash.now[:success] = status.capitalize + @event.description }
      else
        @event.update_attributes(complete: true)
        status = "updated event status from Not Attend to Attended for event"
        timeline_event(status)
        format.js { flash.now[:success] = status.capitalize + @event.description }
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
