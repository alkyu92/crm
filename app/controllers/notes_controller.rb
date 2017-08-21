class NotesController < ApplicationController
  before_action :find_note, only: [:update, :destroy]

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
    @subject = Account.find(params[:account_id]) if params[:account_id]
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]

    @note = @subject.notes.build(params_note)
    @note.user_id = current_user.id

    respond_to do |format|
      if @note.save
        timeline_note("created note")
        format.js { flash.now[:success] = "Note log added!" }
      else
        format.js { flash.now[:danger] = "Failed to add note log!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @note.update(params_note)
        timeline_note("updated note")
        format.js { flash.now[:success] = "Note entry created!" }
      else
        format.js { flash.now[:danger] = "Failed to create note entry!" }
      end
    end
  end

  def destroy
    @note.destroy
    timeline_note("deleted note")
    respond_to do |format|
      format.js { flash.now[:success] = "Note log deleted!" }
    end
  end

  private
  def params_note
    params.require(:note).permit(:title, :description)
  end

  def find_note
    @subject = Account.find(params[:account_id]) if params[:account_id]
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]

    @note = @subject.notes.find(params[:id])

  end
end
