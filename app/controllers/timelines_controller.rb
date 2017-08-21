class TimelinesController < ApplicationController
  before_action :find_timeline

  def show

  end

  def destroy
    @timeline.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def find_timeline
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
    @subject = Account.find(params[:account_id]) if params[:account_id]

    @timeline = @subject.timelines.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
