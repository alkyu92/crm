class TimelinesController < ApplicationController
  before_action :find_timeline, only: [:update, :destroy]

  def destroy
    @timeline.destroy
    flash[:success] = "Timeline deleted!"
    redirect_to request.referrer
  end

  private

  def find_timeline
    @timeline = Timeline.find(params[:id])
  end
end
