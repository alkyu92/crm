class AccountsController < ApplicationController
  def index
    @accounts = Account.page(params[:page]).per(10)
    @account = current_user.accounts.build
  end

  def show
    @account = Account.includes(
    :relationships, :opportunities, :contacts, :user).find(params[:id])
    @subject = @account

    if params[:status] && params[:type]
      @accop = @account.opportunities.includes(
        :account, :stages).where(
        status: params[:status], business_type: params[:type]).page(
        params[:acc_page]).per(10)
    elsif params[:type]
      @accop = @account.opportunities.includes(
        :account, :stages).where(
        business_type: params[:type]).page(
        params[:acc_page]).per(10)
    else
      @accop = Opportunity.includes(:account, :stages).page(params[:acc_page]).per(10)
    end

    @opportunities = Opportunity.includes(
    :relationships, :contacts, :user).where(account_id: @account.id)

    @account.timelines.includes(:user, :activity).each do |tl|
      next if tl.read == true
      tl.update_attributes(read: true)
    end
  end

  def create
    @accounts = Account.page(params[:page]).per(10)
    @account = current_user.accounts.build(params_account)

    respond_to do |format|
      if @account.save
        timeline_account("account", @account.account_name, "created account")
        format.html
        format.js { flash.now[:success] = "Account entry created!" }
      else
        format.js { flash.now[:danger] = "Failed to create account entry!" }
      end
    end

  end

  def update
    @account = Account.find(params[:id])
    @old_name = @account.account_name
    @subject = @account
    respond_to do |format|
      if @account.update(params_account)

        if params[:docs]
          params[:docs].each { |doc|
            @account.documents.create!( doc: doc )
          }
          timeline_account("relatedDocs", @account.account_name, "added attachment file to account")
        end

        if params[:assigned]
          params[:assigned].each { |ct_id|
            @ctct = Contact.find(ct_id)
            @account.relationships.create!(contact: @ctct)
            timeline_account("relatedContacts", @ctct.name, "added association")
          }
        end

        save_timeline_if_any_changes(@old_name)
        format.js { flash.now[:success] = "Account entry updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update account entry!" }
      end
    end
  end

  def destroy
    @accounts = Account.page(params[:page]).per(10)
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.js { flash.now[:success] = "Account deleted!" }
      format.html {
        flash[:success] = "Account deleted!"
        redirect_to accounts_path
      }
    end
  end

  def delete_attachment
    @accounts = Account.page(params[:page]).per(10)
    @account = Account.find(params[:account_id])
    @subject = @account
    @account.documents.find(params[:id]).destroy

    respond_to do |format|
      timeline_account("relatedDocs", @account.account_name, "deleted attachment file from account")
      format.js { flash.now[:success] = "Attachment deleted!" }
    end
  end

  private

  def timeline_account(tactivity, nactivity, action)
    @account.timelines.create!(
    tactivity: tactivity,
    nactivity: nactivity,
    action: action,
    user_id: current_user.id
    )
  end

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
                                    :dummy,
                                    :document,
                                    documents_attributes: [ doc: [] ]
                                    )
  end

  def save_timeline_if_any_changes(old_name)

    if @account.account_name_previously_changed?
      timeline_account("accountDetails",
      old_name, "updated account name from")
    end
    if @account.account_type_previously_changed?
      timeline_account("accountDetails",
      @account.account_type, "updated account type to")
    end
    if @account.website_previously_changed?
      timeline_account("accountDetails",
      @account.website, "updated account website url to")
    end
    if @account.email_previously_changed?
      timeline_account("accountDetails",
      @account.email, "updated account email to")
    end
    if @account.description_previously_changed?
      timeline_account("accountDetails", "", "updated account description")
    end
    if @account.phone_previously_changed?
      timeline_account("accountDetails",
      @account.phone, "updated account phone number to")
    end
    if @account.fax_previously_changed?
      timeline_account("accountDetails",
      @account.fax, "updated account fax number to")
    end
    if @account.industry_previously_changed?
      timeline_account("accountDetails",
      @account.industry, "updated account industry to")
    end
    if @account.number_of_employee_previously_changed?
      timeline_account("accountDetails",
      @account.number_of_employee, "updated account number of employee to")
    end
    if @account.billing_street_previously_changed? ||
      @account.billing_city_previously_changed? ||
      @account.billing_state_previously_changed? ||
      @account.billing_postal_code_previously_changed? ||
      @account.billing_country_previously_changed?

      timeline_account("accountDetails", "", "updated account billing address")

    end
    if @account.shipping_street_previously_changed? ||
      @account.shipping_city_previously_changed? ||
      @account.shipping_state_previously_changed? ||
      @account.shipping_postal_code_previously_changed? ||
      @account.shipping_country_previously_changed?

      timeline_account("accountDetails", "", "updated account shipping address")

    end
  end
end
