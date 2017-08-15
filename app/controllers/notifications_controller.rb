class NotificationsController < ApplicationController
  def index
    @notifications = Timeline.includes(:user).page(params[:page]).per(10)
  end
end
