class NotificationsController < ApplicationController
  def index
    @notifications = Timeline.includes(:activity, :user).order('created_at DESC').page(params[:page]).per(10)
  end
end
