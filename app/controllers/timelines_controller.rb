class TimelinesController < ApplicationController
  before_action :find_timeline, only: [:destroy]

  def destroy
    @timeline.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def find_timeline
    @opportunity = Opportunity.find(params[:opportunity_id])
    @timeline = @opportunity.timelines.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
