class StagesController < ApplicationController
  before_action :find_opportunity
  before_action :find_stage, only: [:destroy, :update_stage_status]

  def create
    @stage = @opportunity.stages.build(params_stage)

    if @stage.save
      @opportunity.timelines.create!(tactivity: "stage", nactivity: @stage.name,
      action: "created stage", user_id: current_user.id)

      flash[:success] = "Stages added!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to add stages!"
      redirect_to request.referrer
    end
  end

  def destroy
    @stage.destroy

    @opportunity.timelines.create!(tactivity: "stage", nactivity: @stage.name,
    action: "deleted stage", user_id: current_user.id)

    flash[:success] = "Opportunity stage deleted!"
    redirect_to request.referrer
  end

  def update_stage_status
    if @stage.complete == true
      @stage.update_attributes(complete: false)

      @opportunity.timelines.create!(tactivity: "stage", nactivity: @stage.name,
      action: "changed stage status from Completed to In Progress", user_id: current_user.id)

      #@opportunity.update_attributes(stage_id: @stage.id) #set current_stage
    else
      @stage.update_attributes(complete: true)

      @opportunity.timelines.create!(tactivity: "stage", nactivity: @stage.name,
      action: "changed stage status from In Progress to Completed", user_id: current_user.id)
    end

    flash[:success] = "Stage status changed!"
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
