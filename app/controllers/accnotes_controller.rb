class AccaccnotesController < ApplicationController
  before_action :find_account
  before_action :find_accnote, only: [:update, :destroy]

  def create
    @accnote = @account.accnotes.build(params_accnote)

    respond_to do |format|
      if @accnote.save
        @account.timelines.create!(tactivity: "note",
        nactivity: @accnote.title, action: "created note", user_id: current_user.id)
        format.js { flash[:success] = "Note log added!" }
      else
        format.js { flash[:danger] = "Failed to add note log!" }
      end
    end

  end

  def update
    if @accnote.update(params_accnote)
      @account.timelines.create!(tactivity: "note",
      nactivity: @accnote.title, action: "updated note", user_id: current_user.id)

      flash[:success] = "Accnote entry created!"
      redirect_to request.referrer
    else
      flash[:danger] = "Failed to create note entry!"
      redirect_to request.referrer
    end
  end

  def destroy
    @accnote.destroy

    @account.timelines.create!(tactivity: "note",
    nactivity: @accnote.title, action: "deleted note", user_id: current_user.id)

    respond_to do |format|
      format.js { flash[:success] = "Note log deleted!" }
    end
  end

  private
  def params_accnote
    params.require(:accnote).permit(:title, :description)
  end

  def find_account
    @account = account.find(params[:account_id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_accnote
    @accnote = Accnote.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
