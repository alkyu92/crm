class ContactsController < ApplicationController
  before_action :find_contact, only: [:show, :update, :destroy]
  def index
    @contacts = Contact.all
  end

  def show

  end

  def create
    @contact = current_user.contacts.build(params_contact)
    respond_to do |format|
      if @contact.save
        format.js { flash[:success] = "Contact created!" }
      else
        format.js { flash[:danger] = "Failed to create contact!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @contact.update(params_contact)
        format.js { flash[:success] = "Contact updated!" }
      else
        format.js { flash[:danger] = "Failed to update contact!" }
      end
    end

  end

  def destroy
    @contact.destroy
    respond_to do |format|
      format.js { flash[:success] = "Contact deleted!" }
    end
  end

  private

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
                                    :mailing_country)
  end

  def find_contact
    @contact = Contact.find(params[:id])
  end
end
