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

    respond_to do |format|
      format.js
    end
    # flash[:success] = "Opportunity stage deleted!"
    # redirect_to request.referrer
  end

  def update_stage_status
    if @stage.status == "In Progress"
      update_status("In Progress", "Completed")
    elsif @stage.status == "Completed"
      update_status("Completed", "In Progress")
    end

    respond_to do |format|
      format.js
    end

    # redirect_to request.referrer
  end

  private
  def params_stage
    params.require(:stage).permit(:name)
  end

  def update_status(previous,current)
    @stage.update_attributes(status: current)

    @opportunity.timelines.create!(tactivity: "stage", nactivity: @stage.name,
    action: "changed stage status from #{previous} to #{current}", user_id: current_user.id)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
    rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_stage
    @stage = Stage.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
