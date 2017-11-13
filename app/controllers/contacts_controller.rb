class ContactsController < ApplicationController
before_action :find_subject,
only: [:create, :edit, :update, :destroy, :destroy_relationship]

  def index
    @contacts = Contact.includes(:relationships).page(params[:page]).per(10)
    session[:last_page] = @contacts.num_pages
  end

  def show
    find_contact
  end

  def new
    @acc_collect = Account.all
    @op_collect = Opportunity.all
    @mrkt_collect = Marketing.all
    @case_collect = Case.all

    @contact = Contact.new
  end

  def create
      @contacts = Contact.includes(:relationships).page(params[:page]).per(10)
      @contact = Contact.new(params_contact)
      @contact.user_id = current_user.id

      if @contact.save
        flash[:success] = "Contact created!"
        assign_contact

        if params[:account_id] || params[:opportunity_id]
          @subject.relationships.create!(contact: @contact)
          # timeline
          @contacttimeline = @subject.timelines.create!(
          action: "#{current_user.name} created contact #{@contact.name}",
          user_id: current_user.id
          )
          redirect_acc_or_op_path
        else
          redirect_to contacts_path(page: @contacts.num_pages, anchor: "contactInfo-#{@contact.id}")
        end

      else
        flash.now[:danger] = "Failed to create contact!"
        redirect_to opportunity_path(params[:opportunity_id], anchor: "relatedContacts")
      end
  end

  def edit
    session[:page] = params[:page]
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
      find_contact
    end

    assign_contact

    if @contact.update(params_contact)
      flash[:success] = "Contact updated!"
      if params[:account_id] || params[:opportunity_id]
        @contacttimeline = @subject.timelines.create!(
        action: "#{current_user.name} updated contact #{@contact.name}",
        user_id: current_user.id
        )
        redirect_acc_or_op_path
      else
        redirect_to contacts_path(page: session[:page], anchor: "contactInfo-#{@contact.id}")
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
      find_contact
      @contacts = Contact.includes(:relationships).page(params[:page]).per(10)
    end

    respond_to do |format|
      @contacttimeline = @subject.timelines.create!(
        action: "#{current_user.name} deleted contact #{@contact.name}",
        user_id: current_user.id
      )
      @contact.destroy
      format.js { flash.now[:success] = "Contact deleted!" }
    end
  end

  def destroy_relationship
    respond_to do |format|
      find_contact
      @relationship = @contact.relationships.find(params[:relationship_id])

      if @relationship.contactable_type == "Account"
        @subject = @contact.accounts.find(@relationship.contactable_id)
      elsif @relationship.contactable_type == "Opportunity"
        @subject = @contact.opportunities.find(@relationship.contactable_id)
      end

      @relationship.destroy
      # timeline
      @contacttimeline = @subject.timelines.create!(
      action: "#{current_user.name} deleted contact association #{@contact.name}",
      user_id: current_user.id
      )
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
          @contacttimeline = @subject.timelines.create!(
          action: "#{current_user.name} added association #{@contact.name}",
          user_id: current_user.id
          )
        elsif assign.split(',')[0] == "Opportunity"
          @subject = Opportunity.find(assign.split(',')[1])
          @contacttimeline = @subject.timelines.create!(
          action: "#{current_user.name} added association #{@contact.name}",
          user_id: current_user.id
          )
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

  def find_contact
    @contact = Contact.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    redirect_to request.referrer
  end

  def find_subject
    if params[:account_id]
      @subject = Account.find(params[:account_id])
    elsif params[:opportunity_id]
      @subject = Opportunity.find(params[:opportunity_id])
    end
  end

  def redirect_acc_or_op_path
    if params[:controller] == "accounts" || params[:account_id]
      redirect_to account_path(@subject, anchor: "relatedContacts")
    elsif params[:controller] == "opportunities" || params[:opportunity_id]
      redirect_to opportunity_path(@subject, anchor: "relatedContacts")
    end
  end
end
