class ContactsController < ApplicationController
  before_action :find_contact, only: [:update, :destroy]

  def index
    @contacts = Contact.all
  end

  def create
    @opportunity = Opportunity.find(params[:opportunity_id])
    @contact = @opportunity.contacts.build(params_contact)
    @contact.user_id = current_user.id

    respond_to do |format|
      if @contact.save
        @opportunity.timelines.create!(tactivity: "contact",
        nactivity: @contact.name, action: "created contact", user_id: current_user.id)
        format.js { flash.now[:success] = "Contact created!" }
      else
        format.js { flash.now[:danger] = "Failed to create contact!" }
      end
    end

  end

  def update
    respond_to do |format|
      if @contact.update(params_contact)
        @opportunity.timelines.create!(tactivity: "contact",
        nactivity: @contact.name, action: "updated contact", user_id: current_user.id)
        format.js { flash.now[:success] = "Contact updated!" }
      else
        format.js { flash.now[:danger] = "Failed to update contact!" }
      end
    end

  end

  def destroy
    @contact.destroy
    @opportunity.timelines.create!(tactivity: "contact",
    nactivity: @contact.name, action: "deleted contact", user_id: current_user.id)
    respond_to do |format|
      format.js { flash.now[:success] = "Contact deleted!" }
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
                                    :mailing_country,
                                    :profile_pic)
  end

  def find_contact
    @opportunity = Opportunity.find(params[:opportunity_id])
    @contact = @opportunity.contacts.find(params[:id])
  end
end
