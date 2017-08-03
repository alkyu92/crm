class NotesController < ApplicationController
  before_action :find_opportunity
  before_action :find_note, only: [:update, :destroy]

  def create
    @note = @opportunity.notes.build(params_note)

    if @note.save
      @opportunity.timelines.create!(tactivity: "note",
      nactivity: @note.description, action: "created note", user_id: current_user.id)

      flash[:success] = "Note Log added!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to add note log!"
      redirect_to request.referrer
    end
  end

  def update
    if @note.update(params_note)
      @opportunity.timelines.create!(tactivity: "note",
      nactivity: @note.description, action: "updated note", user_id: current_user.id)

      flash[:success] = "Note entry created!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to create note entry!"
      redirect_to request.referrer
    end
  end

  def destroy
    @note.destroy

    @opportunity.timelines.create!(tactivity: "note",
    nactivity: @note.description, action: "deleted note", user_id: current_user.id)

    flash[:success] = "Note log deleted!"
    redirect_to request.referrer
  end

  private
  def params_note
    params.require(:note).permit(:title, :description)
  end

  def find_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def find_note
    @note = Note.find(params[:id])
  end
end
