class TimelinesController < ApplicationController
  before_action :find_opportunity
  before_action :find_timeline, only: [:update, :destroy]

  def create
    @timeline = @opportunity.timelines.build(params_timeline)

    if @timeline.save
      flash[:success] = "Timeline entry created!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to create timeline entry!"
      redirect_to request.referrer
    end
  end

  def update
    if @timeline.update(params_timeline)
      flash[:success] = "Timeline entry updated!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to update timeline entry!"
      redirect_to request.referrer
    end
  end

  def destroy
    @timeline.destroy
    flash[:success] = "Timeline entry deleted!"
    redirect_to request.referrer
  end

  private
  def params_timeline
    params.require(:timeline).permit(:nactivity, :tactivity, :info)
  end

  def find_timeline
    @timeline = Timeline.find(params[:id])
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end
end
