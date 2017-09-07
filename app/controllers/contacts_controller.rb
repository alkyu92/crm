class ContactsController < ApplicationController
before_action :find_subject,
only: [:create, :edit, :update, :destroy]

  def index
    @contacts = Contact.includes(:relationships).page(params[:page]).per(10)
  end

  def new
    @acc_collect = Account.all
    @op_collect = Opportunity.all

    @contact = Contact.new
  end

  def create
      @contact = Contact.new(params_contact)
      @contact.user_id = current_user.id

      if @contact.save
        flash[:success] = "Contact created!"
        assign_contact

        if params[:account_id] || params[:opportunity_id]
          @subject.relationships.create!(contact: @contact)
          timeline_contact("created contact")
          redirect_acc_or_op_path
        else
          redirect_to contacts_path
        end

      else
        flash[:danger] = "Failed to create contact!"
        render 'new'
      end
  end

  def edit
    if params[:account_id] || params[:opportunity_id]
      @contact = @subject.contacts.find(params[:id])
    else
      @contact = Contact.find(params[:id])
    end
    collection_for_association
  end

  def update
    if params[:account_id] || params[:opportunity_id]
      @contact = @subject.contacts.find(params[:id])
    else
      @contact = Contact.find(params[:id])
    end

    assign_contact

    if @contact.update(params_contact)
      flash[:success] = "Contact updated!"
      if params[:account_id] || params[:opportunity_id]
        timeline_contact("updated contact")
        redirect_acc_or_op_path
      else
        redirect_to contacts_path(anchor: "contactInfo-#{@contact.id}")
      end
    else
      flash[:danger] = "Failed to update contact!"
      render 'edit'
    end
  end

  def destroy

    if params[:account_id] || params[:opportunity_id]
      @contact = @subject.contacts.find(params[:id])
    else
      @contact = Contact.find(params[:id])
      @contacts = Contact.includes(:relationships).page(params[:page]).per(10)
    end

    respond_to do |format|
      @contact.destroy
      if params[:account_id] || params[:opportunity_id]
        timeline_contact("deleted contact")
      end
      format.js { flash.now[:success] = "Contact deleted!" }
    end
  end

  def destroy_relationship
    respond_to do |format|
      @contact = Contact.find(params[:id])
      @contact.relationships.find(params[:relationship_id]).destroy
      format.js { flash.now[:success] = "Association deleted!"}
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

  def assign_contact
    if params[:assigned]
      params[:assigned].each do |assign|
        if assign.split(',')[0] == "Account"
          @subject = Account.find(assign.split(',')[1])
          timeline_contact("added association")
        elsif assign.split(',')[0] == "Opportunity"
          @subject = Opportunity.find(assign.split(',')[1])
          timeline_contact("added association")
        end

        @contact.relationships.create!(contactable: @subject)

      end
    end
  end

  def collection_for_association
    @acc_collect = []
    Account.all.each do |acc|
      catch :here do

        @contact.accounts.each do |ctac|
          if ctac.id == acc.id
            throw :here
          end
        end
        @acc_collect << acc

      end
    end

    @op_collect = []
    Opportunity.all.each do |op|
      catch :here do

        @contact.opportunities.each do |ctop|
          if ctop.id == op.id
            throw :here
          end
        end
        @op_collect << op

      end
    end

  end

  def find_subject
    @subject = Account.find(params[:account_id]) if params[:account_id]
    @subject = Opportunity.find(params[:opportunity_id]) if params[:opportunity_id]
  end

  def timeline_contact(action)
    @subject.timelines.create!(
    tactivity: "relatedContacts-" + @contact.id.to_s,
    nactivity: @contact.name,
    action: action,
    user_id: current_user.id
    )
  end

  def redirect_acc_or_op_path
    if params[:controller] == "accounts" || params[:account_id]
      redirect_to account_path(@subject, anchor: "relatedContacts")
    elsif params[:controller] == "opportunities" || params[:opportunity_id]
      redirect_to opportunity_path(@subject, anchor: "relatedContacts")
    end
  end

end
