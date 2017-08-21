class TimelinesController < ApplicationController
  before_action :find_timeline, only: [:destroy]

  def show
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
    @subject = Account.find(params[:account_id]) if params[:account_id]
  end

  def destroy
    @timeline.destroy
    respond_to do |format|
      format.js
    end
  end

  def update_read_status
    @timeline = Timeline.find(params[:id])
    @timeline.update_attributes(read: true)

    if @timeline.activity_type == "Opportunity"
      redirect_to opportunity_path(@timeline.activity_id, anchor: @timeline.tactivity)
    elsif @timeline.activity_type == "Account"
      redirect_to account_path(@timeline.activity_id, anchor: @timeline.tactivity)
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
