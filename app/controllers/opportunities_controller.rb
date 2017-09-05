class OpportunitiesController < ApplicationController

  def index
    @opportunities = Opportunity.includes(:account).page(params[:page]).per(10)
    @opportunity = current_user.opportunities.build

    @stages = Stage.all
    @accounts = Account.all

    # for AJAX
    @subject = @opportunity
    @account = Account.find(params[:account_id]) if params[:account_id]
    @subject = @account

  end

  def show
    # for AJAX
    @subject = Opportunity.find(params[:id])
    @opportunity = @subject
    @accounts = Account.all

    @subject.timelines.includes(:activity, :user).each do |tl|
      if tl.read == true
        next
      else
        tl.update_attributes(read: true)
      end
    end
  end

  def create
    @account = Account.find(params[:account_id])
    @opportunity = @account.opportunities.build(params_opportunity)
    @opportunity.user_id = current_user.id

    # for AJAX
    @subject = @opportunity if params[:opportunity_id]
    @subject = @account if params[:account_id]
    @opportunities = Opportunity.page(params[:page]).per(10)


    respond_to do |format|
      if @opportunity.save

        @opportunity.account.timelines.create!(
        tactivity: "",
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
    @opportunity = Opportunity.includes(:user).find(params[:id])
    respond_to do |format|
      # for AJAX
      @subject = @opportunity

      if @opportunity.update(params_opportunity)

          if params[:docs]
            params[:docs].each { |doc|
              @opportunity.documents.create!(doc: doc)
            }
            timeline_opportunity("relatedDocs", @opportunity.name,
            "added attachment file to opportunity")
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
    @opportunity = Opportunity.includes(:user).find(params[:id])
    @opportunity.destroy
    flash[:success] = "Opportunity entry deleted!"
    redirect_to opportunities_path
  end

  def delete_attachment
    respond_to do |format|
      @opportunity = Opportunity.find(params[:opportunity_id])
      @opportunity.documents.find(params[:id]).destroy

      @subject = @opportunity

      timeline_opportunity("relatedDocs", @opportunity.name, "deleted attachment file from opportunity")
      format.js { flash.now[:success] = "Attachment deleted!" }
    end
  end

  private

  def timeline_opportunity(tactivity, nactivity, action)
    @opportunity.timelines.create!(
    tactivity: tactivity,
    nactivity: nactivity,
    action: action,
    user_id: current_user.id
    )
  end

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

  def save_timeline_if_any_changes
    if @opportunity.name_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.name, "updated opportunity name to")
    end
    if @opportunity.business_type_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.business_type, "updated opportunity business type to")
    end
    if @opportunity.probability_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.probability, "updated opportunity probability to")
    end
    if @opportunity.amount_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.amount, "updated opportunity amount to")
    end
    if @opportunity.description_previously_changed?
      timeline_opportunity("opportunityDetails",
      "", "updated opportunity description")
    end
    if @opportunity.status_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.status, "updated opportunity status to")
    end
    if @opportunity.close_date_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.close_date.strftime('%d %b %Y'), "updated opportunity close date to")
    end
    if @opportunity.loss_reason_previously_changed?
      timeline_opportunity("opportunityDetails",
      @opportunity.loss_reason, "updated opportunity loss reason to")
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
