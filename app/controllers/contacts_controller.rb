class ContactsController < ApplicationController
  before_action :find_contact, only: [:show, :edit, :update, :destroy]

  def index
    @contacts = Contact.all
  end

  def show
  end

  def new
    @contact = current_user.contacts.build
  end

  def create
    @contact = current_user.contacts.build(params_contact)

    if @contact.save
      flash[:success] = "Contact entry created!"
      redirect_to @contact
    else
      flash[:danger] = "Failed to create contact entry!"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @contact.update(params_contact)
      flash[:success] = "Contact entry updated!"
      redirect_to @contact
    else
      flash[:danger] = "Failed to update contact!"
      render 'edit'
    end
  end

  def destroy
    @contact.destroy
    flash[:success] = "Contact entry deleted!"
    redirect_to contacts_path
  end

  private

  def params_contact
    params.require(:contact).permit(:name)
  end

  def find_contact
    @contact.find(params[:id])
  end
end
