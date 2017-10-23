class TimelinesController < ApplicationController
  before_action :find_subject, only: [:show, :destroy]

  def show

  end

  def destroy
    @timeline = @subject.timelines.find(params[:id])
    @timeline.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def find_subject
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
    @subject = Account.find(params[:account_id]) if params[:account_id]

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
