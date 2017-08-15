class NotificationsController < ApplicationController
  def index
    @notifications = Timeline.page(params[:page]).per(10)
  end
end
