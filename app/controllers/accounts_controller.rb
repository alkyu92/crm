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
        #timeline(@account.account_name, "created account")
        # notification("account", @account.account_name, "created account")
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
          #timeline(@account.account_name, "added attachment file to account")
        end
        #save_timeline_if_any_changes
        format.js { flash.now[:success] = "Account entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update account entry!" }
      end
    end
  end

  def destroy
    @account.destroy
    flash[:success] = "Account deleted!"
    redirect_to accounts_path
  end

  def delete_attachment
    @account = Account.find(params[:account_id])
    @account.accdocuments.find(params[:id]).destroy

    respond_to do |format|
      #timeline(@account.account_name, "deleted attachment from account")
      format.js { flash.now[:success] = "Attachment deleted!" }
    end
  end

  private

  def params_account
    params.require(:account).permit(:account_name,
                                    :account_type,
                                    :website,
                                    :description,
                                    :email,
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

  def save_timeline_if_any_changes

    if @account.account_name_previously_changed?
      timeline(@account.account_name, "updated account name to")
    end
    if @account.account_type_previously_changed?
      timeline(@account.account_type, "updated account type to")
    end
    if @account.website_previously_changed?
      timeline(@account.website, "updated account website url to")
    end
    if @account.email_previously_changed?
      timeline(@account.email, "updated account email to")
    end
    if @account.description_previously_changed?
      timeline("", "updated account description")
    end
    if @account.phone_previously_changed?
      timeline(@account.phone, "updated account phone number to")
    end
    if @account.fax_previously_changed?
      timeline(@account.fax, "updated account fax number to")
    end
    if @account.industry_previously_changed?
      timeline(@account.industry, "updated account industry to")
    end
    if @account.number_of_employee_previously_changed?
      timeline(@account.number_of_employee, "updated account number of employee to")
    end
    if @account.billing_street_previously_changed? ||
      @account.billing_city_previously_changed? ||
      @account.billing_state_previously_changed? ||
      @account.billing_postal_code_previously_changed? ||
      @account.billing_country_previously_changed?

      timeline("", "updated account billing address")

    end
    if @account.shipping_street_previously_changed? ||
      @account.shipping_city_previously_changed? ||
      @account.shipping_state_previously_changed? ||
      @account.shipping_postal_code_previously_changed? ||
      @account.shipping_country_previously_changed?

      timeline("", "updated account shipping address")

    end
  end
end
