class NotificationsController < ApplicationController
  def index
    @notifications = Timeline.all + Acctimeline.all
  end
end
