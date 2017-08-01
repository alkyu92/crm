class OpportunitiesController < ApplicationController
  before_action :find_opportunity, only: [:show, :edit, :update, :destroy]

  def index
    @opportunities = Opportunity.all
    @opportunity = current_user.opportunities.build

    @stages = Stage.all

    @accounts = Account.all
  end

  def show

  end

  def create
    @opportunity = current_user.opportunities.build(params_opportunity)

    if @opportunity.save
      flash[:success] = "Opportunity entry created!"
      redirect_to @opportunity
    else
      flash[:danger] = "Failed to create opportunity entry!"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @opportunity.update(params_opportunity)
      flash[:success] = "Opportunity entry updated!"
      redirect_to @opportunity
    else
      flash[:danger] = "Failed to update opportunity!"
      render 'edit'
    end
  end

  def destroy
    @opportunity.destroy
    flash[:success] = "Opportunity entry deleted!"
    redirect_to opportunities_path
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
                                         :next_step
                                        )
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Record not found!"
    redirect_to opportunities_path
  end

end
