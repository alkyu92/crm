class NotificationsController < ApplicationController
  def index
    @notifications = Timeline.all.order('created_at DESC').page(params[:page]).per(10)
  end
end
