class AccnotesController < ApplicationController
  before_action :find_account
  before_action :find_accnote, only: [:update, :destroy]

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
    @accnote = @account.accnotes.build(params_accnote)
    @accnote.user_id = current_user.id

    respond_to do |format|
      if @accnote.save
        @account.acctimelines.create!(tactivity: "note",
        nactivity: @accnote.title, action: "created note", user_id: current_user.id)
        format.js { flash.now[:success] = "Note log added!" }
      else
        format.js { flash.now[:danger] = "Failed to add note log!" }
      end
    end
  end

  def update
    respond_to do |format|
      if @accnote.update(params_accnote)
        @account.acctimelines.create!(tactivity: "note",
        nactivity: @accnote.title, action: "updated note", user_id: current_user.id)
        format.js { flash.now[:success] = "Accnote entry created!" }
      else
        format.js { flash.now[:danger] = "Failed to create note entry!" }
      end
    end
  end

  def destroy
    @accnote.destroy

    @account.acctimelines.create!(tactivity: "note",
    nactivity: @accnote.title, action: "deleted note", user_id: current_user.id)

    respond_to do |format|
      format.js { flash.now[:success] = "Note log deleted!" }
    end
  end

  private
  def params_accnote
    params.require(:accnote).permit(:title, :description)
  end

  def find_account
    @account = Account.find(params[:account_id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_accnote
    @accnote = Accnote.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
