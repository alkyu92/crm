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
        @notetimeline = @subject.timelines.create!(
        action: "#{current_user.name} created note <strong>#{@note.title.truncate(50)}</strong>",
        anchor: "relatedNotes",
        user_id: current_user.id
        )
        format.js { flash.now[:success] = "Note log added!" }
      else
        format.js { flash.now[:danger] = "Failed to add note log!" }
      end
    end

  end

  def edit

  end

  def update
    @old_title = @note.title
    @old_description = @note.description

      if @note.update(params_note)
        # timeline
        if @note.title_previously_changed?
          timeline_note("title", @old_title, @note.title)
        elsif @note.description_previously_changed?
          timeline_note("description", @old_description, @note.description)
        end


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
    @notetimeline = @subject.timelines.create!(
    action: "#{current_user.name} deleted note <strong>#{@note.title.truncate(50)}</strong>",
    anchor: "relatedNotes",
    user_id: current_user.id
    )
    respond_to do |format|
      format.js { flash.now[:success] = "Note log deleted!" }
    end

    # AJAX
    @notes = Note.includes(:user, :info).order('created_at').page(params[:page]).per(10)
  end

  private

  def timeline_note(param, old, latest)
    @notetimeline = @subject.timelines.create!(
    action: "#{current_user.name} updated note <strong>#{param}</strong> from
    <strong>#{old}</strong> to <strong>#{latest}</strong>",
    anchor: "relatedNotes",
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
