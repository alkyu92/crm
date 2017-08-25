class StagesController < ApplicationController
  before_action :find_opportunity
  before_action :find_stage, only: [:destroy, :update_stage_status]

  def create
    @subject = @opportunity
    @stage = @opportunity.stages.build(params_stage)

    respond_to do |format|
      if @stage.save
        timeline_stage("created stage")
        format.js { flash.now[:success] = "Opportunity stage created!" }
      else
        format.js { flash.now[:danger] = "Failed to create opportunity stage!" }
      end
    end

  end

  def destroy
    respond_to do |format|
      @subject = @opportunity

      if @stage.status == "In Progress" && (@stage.id != @opportunity.stages.last.id)
        @stage.destroy
        @new_current_stage = @opportunity.stages.where("id > ?", @stage.id).first
        @new_current_stage.update_attributes(status: "In Progress")
        @opportunity.update_attributes(current_stage: @new_current_stage.name)

        @opportunity.stages.each do |stage|
          if stage.id < @new_current_stage.id
            stage.update_attributes(status: "Completed")
          elsif stage.id > @new_current_stage.id
            stage.update_attributes(status: "Waiting")
          end
        end
      end
      @stage.destroy
      timeline_stage("deleted stage")
      format.js { flash.now[:success] = "Opportunity stage deleted!" }
    end
  end

  def update_stage_status
    @subject = @opportunity
    respond_to do |format|
      if @stage.status == "In Progress"
        update_status("In Progress", "Completed", false)
        format.js { flash.now[:success] = "Stage status updated from In Progress to Completed!" }
      elsif @stage.status == "Completed"
        update_status("Completed", "In Progress", true)
        @opportunity.update_attributes(current_stage: @stage.name) # current stage
        format.js { flash.now[:success] = "Stage status updated from Completed to In Progress!" }
      elsif @stage.status == "Waiting"
        update_status("Waiting", "In Progress", true)
        @opportunity.update_attributes(current_stage: @stage.name)
        format.js { flash.now[:success] = "Stage status updated from Waiting to In Progress!" }
      end
    end
  end

  private

  def timeline_stage(action)
    @opportunity.timelines.create!(
    tactivity: "stage",
    nactivity: @stage.name,
    action: action,
    user_id: current_user.id
    )
  end

  def params_stage
    params.require(:stage).permit(:name)
  end

  def update_status(previous,current,boolean)
    @stage.update_attributes(status: current, current_status: boolean)
    @opportunity.stages.each do |stage|
      if stage.id < @stage.id
        stage.update_attributes(status: "Completed")
      elsif stage.id > @stage.id
        stage.update_attributes(status: "Waiting")
      end
    end
    timeline_stage("changed stage status from #{previous} to #{current} for")
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
    rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_stage
    @stage = Stage.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
