class AccountsController < ApplicationController
  before_action :find_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = Account.all
    @account = current_user.accounts.build
  end

  def show
  end

  def create
    @account = current_user.accounts.build(params_account)

    if @account.save
      flash[:success] = "account entry created!"
      redirect_to accounts_path
    else
      flash[:danger] = "Failed to create account entry!"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @account.update(params_account)
      flash[:success] = "account entry updated!"
      redirect_to @account
    else
      flash[:danger] = "Failed to update account!"
      render 'edit'
    end
  end

  def destroy
    @account.destroy
    flash[:success] = "account entry deleted!"
    redirect_to accounts_path
  end

  private

  def params_account
    params.require(:account).permit(:name)
  end

  def find_account
    @account = Account.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
