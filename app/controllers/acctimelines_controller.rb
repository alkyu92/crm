class AcctimelinesController < ApplicationController
  before_action :find_acctimeline, only: [:destroy]

  def destroy
    @acctimeline.destroy
    flash[:success] = "Timeline deleted!"
    redirect_to request.referrer
  end

  private

  def find_acctimeline
    @acctimeline = Acctimeline.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
