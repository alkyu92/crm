class OpportunitiesController < ApplicationController
  before_action :find_all_opportunities, except: [:show, :update]
  before_action :find_opportunity,
  only: [:show, :edit, :update, :destroy]

  def index
    @opportunity = current_user.opportunities.build

    @stages = Stage.all
    @accounts = Account.all

  end

  def show
    @accounts = Account.all
  end

  def create
    @opportunity = current_user.opportunities.build(params_opportunity)

    respond_to do |format|
      if @opportunity.save
        @opportunity.timelines.create!(
        tactivity: "opportunity",
        nactivity: @opportunity.name,
        action: "created opportunity",
        user_id: current_user.id)
        format.js { flash.now[:success] = "Opportunity entry created!" }
      else
        format.js { flash.now[:danger] = "Failed to create opportunity entry!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @opportunity.update(params_opportunity)

          if params[:docs]
            params[:docs].each { |doc|
              @opportunity.documents.create!(doc: doc)
            }
            @opportunity.timelines.create!(
            tactivity: "opportunity",
            nactivity: @opportunity.name,
            action: "added attachment file to opportunity",
            user_id: current_user.id)
          end

        if params[:attached]
          params[:attached].each { |attach|
            @opportunity.documents.where(id: attach).destroy_all
          }
        end

        if params[:delete_all]
          @opportunity.documents.destroy_all
        end

        save_timeline_if_any_changes

        format.js { flash.now[:success] = "Opportunity entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update opportunity!" }
      end
    end
  end

  def destroy
    @opportunity.destroy
    flash[:success] = "Opportunity entry deleted!"
    redirect_to opportunities_path
  end

  def delete_attachment
    @opportunity = Opportunity.find(params[:opportunity_id])
    @opportunity.documents.find(params[:id]).destroy

    respond_to do |format|
      @opportunity.timelines.create!(
      tactivity: "opportunity",
      nactivity: @opportunity.name,
      action: "deleted attachment from opportunity",
      user_id: current_user.id)

      format.js { flash.now[:success] = "Attachment deleted!" }
    end
  end

  private

  def params_opportunity
    params.require(:opportunity).permit( :name,
                                         :stage_id,
                                         :account,
                                         :account_id,
                                         :business_type,
                                         :probability,
                                         :amount,
                                         :description,
                                         :loss_reason,
                                         :close_date,
                                         :status,
                                         :document,
                                         documents_attributes: [ doc: [] ]
                                        )
  end

  def find_opportunity
    @opportunity = Opportunity.includes(:user).find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Record not found!"
    redirect_to opportunities_path
  end

  def find_all_opportunities
    @opportunities = Opportunity.all.includes(:account).page(params[:page]).per(10)
  end

  def save_timeline_if_any_changes
    if @opportunity.name_previously_changed?
      @opportunity.timelines.create!(
      tactivity: "opportunity",
      nactivity: @opportunity.name,
      action: "updated opportunity name to",
      user_id: current_user.id)
    end
    if @opportunity.current_stage_previously_changed?
      @opportunity.timelines.create!(
      tactivity: "opportunity",
      nactivity: @opportunity.current,
      action: "updated opportunity current stage to",
      user_id: current_user.id)
    end
    if @opportunity.business_type_previously_changed?
      @opportunity.timelines.create!(
      tactivity: "opportunity",
      nactivity: @opportunity.business_type,
      action: "updated opportunity business type to",
      user_id: current_user.id)
    end
    if @opportunity.probability_previously_changed?
      @opportunity.timelines.create!(
      tactivity: "opportunity",
      nactivity: @opportunity.probability,
      action: "updated opportunity probability to",
      user_id: current_user.id)
    end
    if @opportunity.amount_previously_changed?
      @opportunity.timelines.create!(
      tactivity: "opportunity",
      nactivity: @opportunity.amount,
      action: "updated opportunity amount to",
      user_id: current_user.id)
    end
    if @opportunity.description_previously_changed?
      @opportunity.timelines.create!(
      tactivity: "opportunity",
      nactivity: "",
      action: "updated opportunity description",
      user_id: current_user.id)
    end
    if @opportunity.status_previously_changed?
      @opportunity.timelines.create!(
      tactivity: "opportunity",
      nactivity: @opportunity.status,
      action: "updated opportunity status to",
      user_id: current_user.id)
    end
    if @opportunity.close_date_previously_changed?
      @opportunity.timelines.create!(
      tactivity: "opportunity",
      nactivity: @opportunity.close_date.strftime('%d %b %Y'),
      action: "updated opportunity closed date to",
      user_id: current_user.id)
    end
    if @opportunity.loss_reason_previously_changed?
      @opportunity.timelines.create!(
      tactivity: "opportunity",
      nactivity: "",
      action: "updated opportunity loss reason",
      user_id: current_user.id)
    end

    if @opportunity.status == "Open"
      @opportunity.close_date = nil
      @opportunity.loss_reason = nil
    elsif @opportunity.status == "Close-Won"
      @opportunity.loss_reason = nil
    end

    @opportunity.save
  end

end
