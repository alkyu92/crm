class ContactsController < ApplicationController
  before_action :find_contact, only: [:update, :destroy]

  def index
    @contacts = Contact.page(params[:page]).per(10)
  end

  def show
    # for AJAX contacts
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
    @subject = Account.find(params[:account_id]) if params[:account_id]
  end

  def create
    # for AJAX contacts
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
    @subject = Account.find(params[:account_id]) if params[:account_id]


    @contact = @subject.contacts.build(params_contact)
    @contact.user_id = current_user.id

    respond_to do |format|
      if @contact.save
        timeline_contact("created contact")
        format.js { flash.now[:success] = "Contact created!" }
      else
        format.js { flash.now[:danger] = "Failed to create contact!" }
      end
    end

  end

  def update
    # for AJAX contacts index
    @contacts = Contact.page(params[:page]).per(10)

    respond_to do |format|
      if @contact.update(params_contact)
        timeline_contact("updated contact")
        format.js { flash.now[:success] = "Contact updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update contact!" }
      end
    end

  end

  def destroy
    @contacts = Contact.page(params[:page]).per(10)
    
    @contact.destroy
    timeline_contact("deleted contact")
    respond_to do |format|
      format.js { flash.now[:success] = "Contact deleted!" }
    end
  end

  private

  def timeline_contact(action)
    @subject.timelines.create!(
    tactivity: "relatedContacts-" + @contact.id.to_s,
    nactivity: @contact.name,
    action: action,
    user_id: current_user.id
    )
  end

  def params_contact
    params.require(:contact).permit(:name,
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

  def find_contact
    @subject = Account.find(params[:account_id]) if params[:account_id]
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]

    @contact = @subject.contacts.find(params[:id])
  end
end
