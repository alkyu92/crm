class StagesController < ApplicationController
  before_action :find_subject
  before_action :find_stage, only: [:update, :destroy, :update_stage_status]

  def index
    respond_to do |format|
      format.js
    end
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def create
    @stage = @subject.stages.build(params_stage)
    @stage.user_id = current_user.id
    @stage.updated_by_id = current_user.id

    respond_to do |format|
      if @stage.save
        timeline_stage("created stage")
        format.js { flash.now[:success] = "Opportunity stage created!" }
      else
        format.js { flash.now[:danger] = "Failed to create opportunity stage!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @stage.update(params_stage)
        @stage.update_attributes(updated_by_id: current_user.id)
        timeline_stage("updated stage")
        format.js { flash.now[:success] = "Opportunity stage updated!" }
      else
        format.js { flash.now[:success] = "Failed to update opportunity stage!" }
      end
    end
  end

  def destroy
      if @stage.status == "In Progress" && (@stage.id != @opportunity.stages.last.id)
        @stage.destroy
        @new_current_stage = @opportunity.stages.where("id > ?", @stage.id).first
        @new_current_stage.update_attributes(status: "In Progress")

        status_updater(@new_current_stage)
      end

      @stage.destroy
      timeline_stage("deleted stage")

      respond_to do |format|
        format.js { flash.now[:success] = "Opportunity stage deleted!" }
      end
  end

  def update_stage_status
    respond_to do |format|
      if @stage.status == "In Progress"
        update_status("In Progress", "Completed", false)
        format.js { flash.now[:success] = "Stage status updated from 'In Progress' to 'Completed'!" }
      elsif @stage.status == "Completed"
        update_status("Completed", "In Progress", true)
        format.js { flash.now[:success] = "Stage status updated from 'Completed' to 'In Progress'!" }
      elsif @stage.status == "Waiting"
        update_status("Waiting", "In Progress", true)
        format.js { flash.now[:success] = "Stage status updated from 'Waiting' to 'In Progress'!" }
      end
    end
  end

  private

  def timeline_stage(action)
    @subject.timelines.create!(
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
    @stage.update_attributes(status: current, current_status: boolean,
    updated_by_id: current_user.id)

    status_updater(@stage)
    
    timeline_stage("changed stage status from '#{previous}' to '#{current}' for")
  end

  def status_updater(current_stage)
    @completed = []
    @waiting = []
    @opportunity.stages.each do |stage|
      if stage.id < current_stage.id
        @completed << stage.id
      elsif stage.id > current_stage.id
        @waiting << stage.id
      end
    end
    Stage.where(id: @completed).update_all(status: "Completed")
    Stage.where(id: @waiting).update_all(status: "Waiting")
  end

  def find_subject
    # for AJAX call
    @subject = Opportunity.find(params[:opportunity_id])
    @opportunity = @subject
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
