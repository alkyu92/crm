class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.includes(:timeline).order('created_at DESC').page(params[:page]).per(10)
  end

  def update_read_status
    @notification = Notification.find(params[:id])
    @notification.update_attributes(read: true)

    redirect_to polymorphic_path(@notification.timeline.activity,
    anchor: @notification.timeline.anchor)
  end

end
