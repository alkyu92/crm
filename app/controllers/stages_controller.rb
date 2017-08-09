class StagesController < ApplicationController
  before_action :find_opportunity
  before_action :find_stage, only: [:destroy, :update_stage_status]

  def create
    @stage = @opportunity.stages.build(params_stage)

    respond_to do |format|
      if @stage.save
        @opportunity.timelines.create!(tactivity: "stage", nactivity: @stage.name,
        action: "created stage", user_id: current_user.id)
        format.js { flash[:success] = "Opportunity stage created!" }
      else
        format.js { flash[:danger] = "Failed to create opportunity stage!" }
      end
    end

  end

  def destroy
    @stage.destroy

    @opportunity.timelines.create!(tactivity: "stage", nactivity: @stage.name,
    action: "deleted stage", user_id: current_user.id)

    respond_to do |format|
      format.js { flash[:success] = "Opportunity stage deleted!" }
    end
  end

  def update_stage_status
    respond_to do |format|
      if @stage.status == "In Progress"
        update_status("In Progress", "Completed")
        format.js { flash[:success] = "Stage status updated from In Progress to Completed!" }
      elsif @stage.status == "Completed"
        update_status("Completed", "In Progress")
        @opportunity.update_attributes(current_stage: @stage.name) # current stage
        format.js { flash[:success] = "Stage status updated from Completed to In Progress!" }
      elsif @stage.status == "Waiting"
        update_status("Waiting", "In Progress")
        @opportunity.update_attributes(current_stage: @stage.name)
        format.js { flash[:success] = "Stage status updated from Waiting to In Progress!" }
      end
    end
  end

  private
  def params_stage
    params.require(:stage).permit(:name)
  end

  def update_status(previous,current)
    @stage.update_attributes(status: current)
    @opportunity.timelines.create!(tactivity: "stage", nactivity: @stage.name,
    action: "changed stage status from #{previous} to #{current} for", user_id: current_user.id)
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
