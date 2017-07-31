class StagesController < ApplicationController
  before_action :find_opportunity

  def create
    @stage = @opportunity.stages.build(params_stage)

    if @stage.save
      flash[:success] = "Stages added!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to add stages!"
      redirect_to request.referrer
    end
  end

  private
  def params_stage
    params.require(:stage).permit(:name)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end
end
