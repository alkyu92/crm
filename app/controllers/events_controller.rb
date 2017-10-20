class EventsController < ApplicationController
  before_action :find_subject
  before_action :find_event, only: [:edit, :update, :destroy, :update_event_status]

  def index
    @events = Event.includes(:user, :opportunity).order('event_date').page(params[:page]).per(10)

    # AJAX
    @opportunity = Opportunity.find_by_id(session[:op_id])
    @opevent = @opportunity.events.includes(
    :user).order('event_date').page(params[:event_page]).per(10) if @opportunity
  end

  def show

  end

  def create
    @event = @subject.events.build(params_event)
    @event.user_id = current_user.id

    respond_to do |format|
      if @event.save
        timeline_event("created event")
        format.js { flash.now[:success] = "Event log created!" }
      else
        format.js { flash.now[:success] = "Failed to create event log!" }
      end
    end

    # AJAX
    session[:op_id] = @event.opportunity.id
    @opportunity = Opportunity.find(@event.opportunity)
    @opevent = @opportunity.events.includes(
    :user).order('event_date').page(params[:event_page]).per(10)
  end

  def edit

  end

  def update
      if @event.update(params_event)

        if params[:attended]
          if @event.complete == true
            @event.update_attributes(complete: false)
          else
            @event.update_attributes(complete: true)
          end
        end

        timeline_event("updated event")
        flash[:success] = "Event entry updated!"
        redirect_to opportunity_path(@opportunity, anchor: "event-eventInfo-#{@event.id}")
      else
        flash[:danger] = "Failed to update event entry!"
        redirect_to opportunity_path(@opportunity, anchor: "event-eventInfo-#{@event.id}")
      end

  end

  def destroy
    # AJAX
    @opportunity = Opportunity.find_by_id(@event.opportunity.id)
    @opevent = @opportunity.events.includes(:user).order('event_date').page(params[:task_page]).per(10)

    @event.destroy
    timeline_event("deleted event")

    respond_to do |format|
      format.html { redirect_to opportunity_path(@opportunity, anchor: "event") }
      format.js { flash[:success] = "Event deleted!" }
    end

    # AJAX
    @events = Event.includes(:user, :opportunity).order('event_date').page(params[:page]).per(10)
  end

  def update_event_status
    respond_to do |format|
      if @event.complete == true
        @event.update_attributes(complete: false)
        status = "updated event status from Attended to Not Attend for event "
        timeline_event(status)
        format.js { flash.now[:success] = status.capitalize + @event.description.truncate(50) }
      else
        @event.update_attributes(complete: true)
        status = "updated event status from Not Attend to Attended for event "
        timeline_event(status)
        format.js { flash.now[:success] = status.capitalize + @event.description.truncate(50) }
      end
    end
  end

  private

  def timeline_event(action)
    @subject.timelines.create!(
    tactivity: "event-" + @event.id.to_s,
    nactivity: @event.description.truncate(50),
    action: action,
    user_id: current_user.id
    )
  end

  def params_event
    params.require(:event).permit(:description, :event_date)
  end

  def find_subject
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
    @opportunity = @subject

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_event
    find_subject
    @event = @subject.events.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
