class RelationshipsController < ApplicationController
  def destroy
    @relationship = Relationship.find()
    @relationship.destroy

    respond_to do |format|
      format.js { flash.now[:success] = "Relationship deleted!"}
    end
  end
end
