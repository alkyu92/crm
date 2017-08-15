class AccountsController < ApplicationController
  before_action :find_account, only: [:show, :update, :destroy]
  before_action :find_all_account, except: [:show, :update]

  def index
    @account = current_user.accounts.build
  end

  def show
  end

  def create
    @account = current_user.accounts.build(params_account)

    respond_to do |format|
      if @account.save
        @account.acctimelines.create!(tactivity: "account", nactivity: @account.account_name,
        action: "created account", user_id: current_user.id)
        format.js { flash.now[:success] = "Account entry created!" }
      else
        format.js { flash.now[:danger] = "Failed to create account entry!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @account.update(params_account)

        if params[:accdocs]
          params[:accdocs].each { |accdoc|
            @account.accdocuments.create!( accdoc: accdoc )
          }
        end

        @account.acctimelines.create!(tactivity: "account", nactivity: @account.account_name,
        action: "updated account", user_id: current_user.id)

        format.js { flash.now[:success] = "Account entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update account entry!" }
      end
    end
  end

  def destroy
    @account.destroy
    respond_to do |format|
      format.js { flash.now[:success] = "Account entry deleted!" }
    end
  end

  def delete_attachment
    @account = Account.find(params[:account_id])
    @account.accdocuments.find(params[:id]).destroy

    respond_to do |format|
      @account.acctimelines.create!(tactivity: "account", nactivity: @account.account_name,
      action: "deleted attachment from account", user_id: current_user.id)
      format.js { flash.now[:success] = "Attachment deleted!" }
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
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end

  def find_all_account
    @accounts = Account.page(params[:page]).per(10)

  rescue ActiveRecord::RecordNotFound
    flash.now[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
