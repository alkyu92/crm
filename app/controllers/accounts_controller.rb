class AccountsController < ApplicationController
  before_action :find_account, only: [:show, :update, :destroy]

  def index
    @accounts = Account.all
    @account = current_user.accounts.build
  end

  def show
  end

  def create
    @account = current_user.accounts.build(params_account)

    if @account.save
      @account.acctimelines.create!(tactivity: "account", nactivity: @account.account_name,
      action: "created account", user_id: current_user.id)

      flash[:success] = "Account entry created!"
      redirect_to @account
    else
      flash[:danger] = "Failed to create account entry!"
      redirect_to accounts_path
    end
  end

  def update
    #respond_to do |format|
      if @account.update(params_account)

        if params[:accdocs]
          params[:accdocs].each { |accdoc|
            @account.accdocuments.create!( accdoc: accdoc )
          }
        end

        @account.acctimelines.create!(tactivity: "account", nactivity: @account.account_name,
        action: "updated account", user_id: current_user.id)
        redirect_to root_path
        #format.js { flash[:success] = "Account entry updated!" }
      else
        #format.js { flash[:danger] = "Failed to update account entry!" }
      end
    #end
  end

  def destroy
    @account.destroy
    flash[:success] = "Account entry deleted!"
    redirect_to accounts_path
  end

  def delete_attachment
    @account = Account.find(params[:account_id])
    @account.accdocuments.find(params[:id]).destroy
    respond_to do |format|
      format.js { flash[:success] = "Attachment deleted!" }
    end
  end

  private

  def params_account
    params.require(:account).permit(:account_name,
                                    :account_type,
                                    :website,
                                    :description,
                                    :phone,
                                    :fax,
                                    :industry,
                                    :number_of_employee,
                                    :billing_street,
                                    :billing_city,
                                    :billing_state,
                                    :billing_postal_code,
                                    :billing_country,
                                    :shipping_street,
                                    :shipping_city,
                                    :shipping_state,
                                    :shipping_postal_code,
                                    :shipping_country,
                                    :accdocument,
                                    accdocuments_attributes: [ accdoc: [] ]
                                    )
  end

  def find_account
    @account = Account.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
