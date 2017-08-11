class AcctimelinesController < ApplicationController
  before_action :find_acctimeline, only: [:destroy]

  def destroy
    @acctimeline.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def find_acctimeline
    @account = Account.find(params[:account_id])
    @acctimeline = @account.acctimelines.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
