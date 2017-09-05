class RelationshipsController < ApplicationController
  def destroy
    @subject = Account.find(params[:account_id]) if params[:account_id]
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]

    @relationship = Relationship.find(params[:id])
    @relationship.destroy

    respond_to do |format|
      format.js { flash.now[:success] = "Relationship deleted!"}
    end
  end
end
