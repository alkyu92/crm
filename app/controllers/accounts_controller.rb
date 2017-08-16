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

        save_timeline_if_any_changes

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
      @account.acctimelines.create!(
      nactivity: @account.account_name,
      action: "updated account name to",
      user_id: current_user.id)
    end
    if @account.account_type_previously_changed?
      @account.acctimelines.create!(
      nactivity: @account.account_type,
      action: "updated account type to",
      user_id: current_user.id)
    end
    if @account.website_previously_changed?
      @account.acctimelines.create!(
      nactivity: @account.website,
      action: "updated account website url to",
      user_id: current_user.id)
    end
    if @account.email_previously_changed?
      @account.acctimelines.create!(
      nactivity: @account.email,
      action: "updated account email to",
      user_id: current_user.id)
    end
    if @account.description_previously_changed?
      @account.acctimelines.create!(
      nactivity: "",
      action: "updated account description",
      user_id: current_user.id)
    end
    if @account.phone_previously_changed?
      @account.acctimelines.create!(
      nactivity: @account.phone,
      action: "updated account phone number to",
      user_id: current_user.id)
    end
    if @account.fax_previously_changed?
      @account.acctimelines.create!(
      nactivity: @account.fax,
      action: "updated account fax number to",
      user_id: current_user.id)
    end
    if @account.industry_previously_changed?
      @account.acctimelines.create!(
      nactivity: @account.industry,
      action: "updated account industry to",
      user_id: current_user.id)
    end
    if @account.number_of_employee_previously_changed?
      @account.acctimelines.create!(
      nactivity: @account.number_of_employee,
      action: "updated account number of employee to",
      user_id: current_user.id)
    end
    if @account.billing_street_previously_changed? ||
      @account.billing_city_previously_changed? ||
      @account.billing_state_previously_changed? ||
      @account.billing_postal_code_previously_changed? ||
      @account.billing_country_previously_changed?
      @account.acctimelines.create!(
      nactivity: "",
      action: "updated account billing address",
      user_id: current_user.id)
    end
    if @account.shipping_street_previously_changed? ||
      @account.shipping_city_previously_changed? ||
      @account.shipping_state_previously_changed? ||
      @account.shipping_postal_code_previously_changed? ||
      @account.shipping_country_previously_changed?
      @account.acctimelines.create!(
      nactivity: "",
      action: "updated account shipping address",
      user_id: current_user.id)
    end
  end
end
