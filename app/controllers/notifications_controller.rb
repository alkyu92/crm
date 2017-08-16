class NotificationsController < ApplicationController
  def index
    # @notifications = Notification.all.page(params[:page]).per(10)
    @notifications = Timeline.all.page(params[:page]).per(10)
  end
end
