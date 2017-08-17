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
    @account = Account.find(params[:account_id])
    @opportunity = @account.opportunities.build(params_opportunity)
    @opportunity.user_id = current_user.id
    respond_to do |format|
      if @opportunity.save
        timeline(@opportunity.name, "created opportunity")

        @opportunity.account.acctimelines.create!(
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
            timeline(@opportunity.name, "added attachment file to opportunity")
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
      timeline(@opportunity.name, "deleted attachment from opportunity")
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
      timeline(@opportunity.name, "updated opportunity name to")
    end
    if @opportunity.current_stage_previously_changed?
      timeline(@opportunity.current, "updated opportunity current stage to")
    end
    if @opportunity.business_type_previously_changed?
      timeline(@opportunity.business_type, "updated opportunity business type to")
    end
    if @opportunity.probability_previously_changed?
      timeline(@opportunity.probability, "updated opportunity probability to")
    end
    if @opportunity.amount_previously_changed?
      timeline(@opportunity.amount, "updated opportunity amount to")
    end
    if @opportunity.description_previously_changed?
      timeline("", "updated opportunity description")
    end
    if @opportunity.status_previously_changed?
      timeline(@opportunity.status, "updated opportunity status to")
    end
    if @opportunity.close_date_previously_changed?
      timeline(@opportunity.close_date, "updated opportunity close date to")
    end
    if @opportunity.loss_reason_previously_changed?
      timeline(@opportunity.loss_reason, "updated opportunity loss reason to")
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
