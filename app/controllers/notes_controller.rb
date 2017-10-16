class NotesController < ApplicationController
  before_action :find_subject
  before_action :find_note, only: [:edit, :update, :destroy]

  def index
    if params[:type]
      @notes = Note.includes(:user, :info).where(
      info_type: params[:type]).order('created_at').page(params[:page]).per(10)
    else
      @notes = Note.includes(:user, :info).order('created_at').page(params[:page]).per(10)
    end
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def create
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

  def edit

  end

  def update
      if @note.update(params_note)
        timeline_note("updated note")
        flash[:success] = "Note entry created!"
        if params[:controller] == "accounts" || params[:account_id]
          redirect_to account_path(@subject, anchor: "relatedNotes")
        elsif params[:controller] == "opportunities" || params[:opportunity_id]
          redirect_to opportunity_path(@subject, anchor: "relatedNotes")
        end
      else
        flash[:danger] = "Failed to create note entry!"
        render 'edit'
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

  def timeline_note(action)
    @subject.timelines.create!(
    tactivity: "relatedNotes-" + @note.id.to_s,
    nactivity: @note.title,
    action: action,
    user_id: current_user.id
    )
  end

  def params_note
    params.require(:note).permit(:title, :description)
  end

  def find_subject
    @subject = Account.find(params[:account_id]) if params[:account_id]
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
  end

  def find_note
    find_subject
    @note = @subject.notes.find(params[:id])
  end
end
