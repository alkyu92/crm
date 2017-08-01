class StagesController < ApplicationController
  before_action :find_opportunity
  before_action :find_stage, only: [:destroy, :update_stage_status]

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

  def destroy
    @stage.destroy
    flash[:success] = "Opportunity stage deleted!"
    redirect_to request.referrer
  end

  def update_stage_status
    if @stage.complete == true
      @stage.update_attributes(complete: false)
    else
      @stage.update_attributes(complete: true)
    end

    flash[:success] = "Stage completed!"
    redirect_to request.referrer
  end

  private
  def params_stage
    params.require(:stage).permit(:name)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def find_stage
    @stage = Stage.find(params[:id])
  end
end
