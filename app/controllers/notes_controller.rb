class NotesController < ApplicationController
  before_action :find_opportunity
  before_action :find_note, only: [:update, :destroy]

  def create
    @note = @opportunity.notes.build(params_note)
    @note.user_id = current_user.id
    
    respond_to do |format|
      if @note.save
        @opportunity.timelines.create!(tactivity: "note",
        nactivity: @note.title, action: "created note", user_id: current_user.id)
        format.js { flash.now[:success] = "Note log added!" }
      else
        format.js { flash.now[:danger] = "Failed to add note log!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @note.update(params_note)
        @opportunity.timelines.create!(tactivity: "note",
        nactivity: @note.title, action: "updated note", user_id: current_user.id)
        format.js { flash.now[:success] = "Note entry created!" }
      else
        format.js { flash.now[:danger] = "Failed to create note entry!" }
      end
    end
  end

  def destroy
    @note.destroy

    @opportunity.timelines.create!(tactivity: "note",
    nactivity: @note.title, action: "deleted note", user_id: current_user.id)

    respond_to do |format|
      format.js { flash.now[:success] = "Note log deleted!" }
    end
  end

  private
  def params_note
    params.require(:note).permit(:title, :description)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_note
    @note = Note.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
