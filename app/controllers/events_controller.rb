class EventsController < ApplicationController
  before_action :find_subject
  before_action :find_event, only: [:edit, :update, :destroy, :update_event_status]

  def index
    @events = Event.order('event_date').page(params[:page]).per(10)
    # @events = []

    # AJAX
    # @subject = Opportunity.find_by_id(session[:op_id])
    # @opevent = @subject.events.includes(
    # :user).order('event_date').page(params[:event_page]).per(10) if @subject
  end

  def show

  end

  def create
    @event = @subject.events.build(params_event)
    @event.user_id = current_user.id

    respond_to do |format|
      if @event.save
        @eventtimeline = @subject.timelines.create!(
        action: "#{current_user.name} created event
        <strong>#{@event.description.truncate(50)}</strong>",
        user_id: current_user.id
        )
        format.js { flash.now[:success] = "Event log created!" }
      else
        format.js { flash.now[:success] = "Failed to create event log!" }
      end
    end

    # AJAX
    session[:op_id] = @event.polyevent.id

    @subject = Opportunity.find(@event.polyevent) if params[:opportunity_id]
    @subject = Marketing.find(@event.polyevent) if params[:marketing_id]
    @subject = Case.find(@event.polyevent) if params[:case_id]

    @opevent = @subject.events.includes(
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

        save_if_any_changes

        flash.now[:success] = "Event entry updated!"
        redirect_to polymorphic_path(@subject, anchor: "event-eventInfo-#{@event.id}")
      else
        flash.now[:danger] = "Failed to update event entry!"
        redirect_to polymorphic_path(@subject, anchor: "event-eventInfo-#{@event.id}")
      end

  end

  def destroy
    # AJAX
    @subject = Opportunity.find_by_id(@event.polyevent.id) if params[:opportunity_id]
    @subject = Marketing.find_by_id(@event.polyevent.id) if params[:marketing_id]
    @subject = Case.find_by_id(@event.polyevent.id) if params[:case_id]

    @opevent = @subject.events.includes(:user).order(
    'event_date').page(params[:task_page]).per(10)

    @eventtimeline = @subject.timelines.create!(
    action: "#{current_user.name} deleted event <strong>#{@event.description.truncate(50)}</strong>",
    user_id: current_user.id
    )
    @event.destroy

    respond_to do |format|
      format.html { redirect_to polymorphic_path(@subject, anchor: "event") }
      format.js { flash[:success] = "Event deleted!" }
    end

    # AJAX
    @events = Event.includes(:user, :subject).order('event_date').page(params[:page]).per(10)
  end

  def update_event_status
    respond_to do |format|
      if @event.complete == true
        @event.update_attributes(complete: false)

        @eventtimeline = @subject.timelines.create!(
        action: "#{current_user.name} updated event status
        from <strong>Will Attend</strong> to <strong>Not Attend</strong> for
        event <strong>#{@event.description.truncate(50)}</strong>",
        user_id: current_user.id
        )
        format.js { flash.now[:success] = status.capitalize + @event.description.truncate(50) }
      else
        @event.update_attributes(complete: true)

        @eventtimeline = @subject.timelines.create!(
        action: "#{current_user.name} updated event status
        from <strong>Not Attend</strong> to <strong>Will Attend</strong> for
        event <strong>#{@event.description.truncate(50)}</strong>",
        user_id: current_user.id
        )
        format.js { flash.now[:success] = status.capitalize + @event.description.truncate(50) }
      end
    end
  end

  private

  def timeline_event(param, old, latest)
    @eventtimeline = @subject.timelines.create!(
    action: "#{current_user.name} updated event <strong>#{param}</strong> from
    <strong>#{old}</strong> to <strong>#{latest}</strong>",
    user_id: current_user.id
    )
  end

  def save_if_any_changes
    if @event.description_previously_changed?
      timeline_event("description", @old_description, @event.description.truncate(50))
    end
    if @event.event_date_previously_changed?
      timeline_event("datetime start", @old_start, @event.event_date)
    end
    if @event.event_finish_previously_changed?
      timeline_event("datetime finish", @old_finish, @event.event_finish)
    end
  end

  def params_event
    params.require(:event).permit(:description, :event_date, :event_finish)
  end

  def find_subject
    @subject = Opportunity.find(params[:subject_id]) if params[:subject_id]
    @subject = Case.find(params[:case_id]) if params[:case_id]
    @subject = Marketing.find(params[:marketing_id]) if params[:marketing_id]

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
