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
        @opportunity.timelines.create!(tactivity: "opportunity", nactivity: @opportunity.name,
        action: "created opportunity", user_id: current_user.id)
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
          end

        if params[:attached]
          params[:attached].each { |attach|
            @opportunity.documents.where(id: attach).destroy_all
          }
        end

        if params[:delete_all]
          @opportunity.documents.destroy_all
        end

        @opportunity.timelines.create!(tactivity: "opportunity", nactivity: @opportunity.name,
        action: "updated opportunity", user_id: current_user.id)

        format.js { flash.now[:success] = "Opportunity entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update opportunity!" }
      end
    end

  end

  def destroy
    @opportunity.destroy
    respond_to do |format|
      format.js { flash.now[:success] = "Opportunity entry deleted!" }
    end
  end

  def delete_attachment
    @opportunity = Opportunity.find(params[:opportunity_id])
    @opportunity.documents.find(params[:id]).destroy
    respond_to do |format|
      format.js { flash.now[:success] = "Attachment deleted!" }
    end
  end

  private

  def params_opportunity
    params.require(:opportunity).permit( :name,
                                         :stage_id,
                                         :account_id,
                                         :business_type,
                                         :probability,
                                         :amount,
                                         :description,
                                         :loss_reason,
                                         :close_date,
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
    @opportunities = Opportunity.all.includes(:account)
  end

end
