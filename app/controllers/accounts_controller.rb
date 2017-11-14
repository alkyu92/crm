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

      if params[:type] == "Opportunity"
        @accsbj = @account.opportunities.includes(:account, :stages).where(
        status: params[:status]).page(params[:sbj_page]).per(10)
      elsif params[:type] == "Case"
        @accsbj = @account.cases.includes(:account, :stages).where(
        status: params[:status]).page(params[:sbj_page]).per(10)
      elsif params[:type] == "Marketing"
        @accsbj = @account.marketings.includes(:account, :stages).where(
        status: params[:status]).page(params[:sbj_page]).per(10)
      end

    else
      @accsbj = @account.opportunities.includes(:account, :stages).where(
      status: params[:status]).page(params[:sbj_page]).per(10)
    end

  end

  def create
    @accounts = Account.page(params[:page]).per(10)
    @account = current_user.accounts.build(params_account)

    if @account.save
      # timeline
      @acctimeline = @account.timelines.create!(
      action: "#{current_user.name} created account <strong>#{@account.name}</strong>",
      anchor: "accountDetails",
      user_id: current_user.id
      )
      flash[:success] = "Account created!"
      redirect_to account_path(@account)
    else
      flash[:danger] = "Failed to create account!"
      redirect_to accounts_path(anchor: "accountModalForm")
    end

  end

  def update
    @account = Account.find(params[:id])

    @old_name = @account.name
    @old_type = @account.account_type
    @old_website = @account.website
    @old_email = @account.email
    @old_description = @account.description
    @old_phone = @account.phone
    @old_fax = @account.fax
    @old_industry = @account.industry
    @old_employee = @account.employee

    @subject = @account

    respond_to do |format|
      if @account.update(params_account)

        if params[:docs]
          params[:docs].each { |doc|
            @account.documents.create!( doc: doc )
          }
          # timeline
          @acctimeline = @account.timelines.create!(
          action: "#{current_user.name} added attachment
          to account <strong>#{@account.name}</strong>",
          user_id: current_user.id
          )
        end

        if params[:assigned]
          @ctct = Contact.where(id: params[:assigned])
          @values = @ctct.map {|ct|
            "(#{ct.id}, #{@account.id}, 'Account', '#{ct.created_at}', '#{ct.updated_at}')"}.join(',')

          @sql = "INSERT INTO relationships (
          'contact_id', 'contactable_id', 'contactable_type', 'created_at', 'updated_at'
          ) VALUES #{@values}"

          ActiveRecord::Base.connection.execute(@sql)
          # timeline
          @acctimeline = @account.timelines.create!(
          action: "#{current_user.name} assigned
          <strong>#{@ctct.map {|ct| ct.name}.join(' ,')}</strong>
          to account <strong>#{@account.name}</strong>",
          user_id: current_user.id
          )
        end
        # timeline update
        save_timeline_if_any_changes

        format.html {
          flash[:success] = "Account entry updated!"
          redirect_to account_path(@account)
        }
        format.js { flash[:success] = "Account entry updated!" }
      else
        flash[:danger] = "Failed to update account entry!"
        format.html { redirect_to account_path(@account, anchor: "accountModalForm") }
        format.js
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
      @acctimeline = @account.timelines.create!(
      action: "#{current_user.name} deleted attachment from
      <strong>#{@account.name}</strong>",
      anchor: "relatedDocs",
      user_id: current_user.id
      )
      format.js { flash.now[:success] = "Attachment deleted!" }
    end
  end

  private

  def timeline_account(param,old,latest)
    @acctimeline = @account.timelines.create!(
    action: "#{current_user.name} updated account <strong>#{param}</strong>
    from <strong>#{old}</strong> to <strong>#{latest}</strong>",
    anchor: "accountDetails",
    user_id: current_user.id
    )
    notify_user(@acctimeline.id)
  end

  def params_account
    params.require(:account).permit(:name,
                                    :account_type,
                                    :website,
                                    :description,
                                    :email,
                                    :phone,
                                    :fax,
                                    :industry,
                                    :employee,
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

  def save_timeline_if_any_changes

    if @account.name_previously_changed?
      timeline_account("name", @old_name, @account.name)
    end
    if @account.account_type_previously_changed?
      timeline_account("type", @old_type, @account.account_type)
    end
    if @account.website_previously_changed?
      timeline_account("website URL", @old_website, @account.website)
    end
    if @account.email_previously_changed?
      timeline_account("email", @old_email, @account.email)
    end
    if @account.description_previously_changed?
      timeline_account("description", @old_description, @account.description)
    end
    if @account.phone_previously_changed?
      timeline_account("phone number", @old_phone, @account.phone)
    end
    if @account.fax_previously_changed?
      timeline_account("fax number", @old_fax, @account.fax)
    end
    if @account.industry_previously_changed?
      timeline_account("industry", @old_industry, @account.industry)
    end
    if @account.employee_previously_changed?
      timeline_account("number of employees", @old_employee, @account.employee)
    end
    if @account.billing_street_previously_changed? ||
      @account.billing_city_previously_changed? ||
      @account.billing_state_previously_changed? ||
      @account.billing_postal_code_previously_changed? ||
      @account.billing_country_previously_changed?

      @acctimeline = @account.timelines.create!(
      action: "#{current_user.name} updated account billing address",
      user_id: current_user.id
      )
    end
    if @account.shipping_street_previously_changed? ||
      @account.shipping_city_previously_changed? ||
      @account.shipping_state_previously_changed? ||
      @account.shipping_postal_code_previously_changed? ||
      @account.shipping_country_previously_changed?

      @acctimeline = @account.timelines.create!(
      action: "#{current_user.name} updated account shipping address",
      user_id: current_user.id
      )
    end
  end
end
