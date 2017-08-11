class AcccontactsController < ApplicationController
  before_action :find_acccontact, only: [ :update, :destroy]

  def index
    @acccontacts = Acccontact.all
  end

  def create
    @account = Account.find(params[:account_id])
    @acccontact = @account.acccontacts.build(params_acccontact)
    @acccontact.user_id = current_user.id

    respond_to do |format|
      if @acccontact.save
        @account.acctimelines.create!(tactivity: "contact",
        nactivity: @acccontact.name, action: "created contact", user_id: current_user.id)
        format.js { flash.now[:success] = "Contact created!" }
      else
        format.js { flash.now[:danger] = "Failed to create contact!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @acccontact.update(params_acccontact)
        @account.acctimelines.create!(tactivity: "contact",
        nactivity: @acccontact.name, action: "updated contact", user_id: current_user.id)
        format.js { flash.now[:success] = "Contact updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update contact!" }
      end
    end

  end

  def destroy
    @acccontact.destroy
    @account.acctimelines.create!(tactivity: "contact",
    nactivity: @acccontact.name, action: "deleted contact", user_id: current_user.id)
    respond_to do |format|
      format.js { flash.now[:success] = "Contact deleted!" }
    end
  end

  private

  def params_acccontact
    params.require(:acccontact).permit(:name,
                                    :title,
                                    :department,
                                    :email,
                                    :phone,
                                    :fax,
                                    :mailing_street,
                                    :mailing_city,
                                    :mailing_state,
                                    :mailing_postal_code,
                                    :mailing_country,
                                    :profile_pic)
  end

  def find_acccontact
    @account = Account.find(params[:account_id])
    @acccontact = @account.acccontacts.find(params[:id])
  end
end
