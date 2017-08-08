class ContactsController < ApplicationController
  before_action :find_contact, only: [:show, :edit, :update, :destroy]

  def index
    @contacts = Contact.all
    @contact = current_user.contacts.build
  end

  def show
  end

  def create
    @contact = current_user.contacts.build(params_contact)

    if @contact.save
      flash[:success] = "contact entry created!"
      redirect_to contacts_path
    else
      flash[:danger] = "Failed to create contact entry!"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @contact.update(params_contact)
      flash[:success] = "contact entry updated!"
      redirect_to @contact
    else
      flash[:danger] = "Failed to update contact!"
      render 'edit'
    end
  end

  def destroy
    @contact.destroy
    flash[:success] = "contact entry deleted!"
    redirect_to contacts_path
  end

  private

  def params_contact
    params.require(:contact).permit(:name, :title, :department, :phone, :email, :address)
  end

  def find_contact
    @contact = Contact.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Can't find records!"
    redirect_to root_path
  end
end
