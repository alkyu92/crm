class UsersController < ApplicationController
  before_action :find_user, only: [:show]

  def index
    @users = User.all
  end

  def show
    @calls = @user.calls.includes(:opportunity).page(params[:page_call]).per(5)
    @events = @user.events.includes(:opportunity).page(params[:page_event]).per(5)
    @tasks = @user.tasks.includes(:opportunity).page(params[:page_task]).per(5)

    @userop = @user.opportunities.page(params[:page_op]).per(5)
    @useracc = @user.accounts.page(params[:page_acc]).per(5)
  end

  private

  def find_user
    @user = User.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
