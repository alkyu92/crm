class ContactsController < ApplicationController

  def index
    @contacts = Contact.page(params[:page]).per(10)
  end

  def new
    @contact = Contact.new
  end

  def create
      @subject = Account.find(params[:account_id]) if params[:account_id]
      @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]

      @contact = Contact.new(params_contact)
      @contact.user_id = current_user.id

      if @contact.save
        if params[:account_id] || params[:opportunity_id]
          @subject.relationships.create!(contact: @contact)
          redirect_to @subject
        else
          redirect_to contacts_path
        end
        flash[:success] = "Contact created!"
      else
        flash[:danger] = "Failed to create contact!"
        redirect_to contacts_path
      end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])

    if @contact.update(params_contact)
      flash[:success] = "Contact updated!"
      redirect_to contacts_path
    else
      flash[:danger] = "Failed to update contact"
      redirect_to contacts_path
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    flash[:success] = "Contact deleted!"
    redirect_to request.referrer
  end

  def delete_association
    redirect_to request.referrer
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
