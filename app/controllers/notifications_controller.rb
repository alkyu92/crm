class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order('created_at DESC').page(params[:page]).per(10)
  end

  def update_read_status
    @notification = Notification.find(params[:id])
    @notification.update_attributes(read: true)

    if @notification.timeline.activity_type == "Opportunity"
      redirect_to opportunity_path(@notification.timeline.activity_id,
      anchor: @notification.timeline.tactivity)
    elsif @notification.timeline.activity_type == "Account"
      redirect_to account_path(@notification.timeline.activity_id,
      anchor: @notification.timeline.tactivity)
    end
  end

end
