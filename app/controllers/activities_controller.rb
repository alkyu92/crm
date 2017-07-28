class ActivitiesController < ApplicationController
  before_action :find_activity, only: [:show, :edit, :update, :destroy]

  def index
    @activities = Activity.all
  end

  def show
  end

  def new
    @activity = current_user.activities.build
  end

  def create
    @activity = current_user.activities.build(params_activity)

    if @activity.save
      flash[:success] = "Activity entry created!"
      redirect_to @activity
    else
      flash[:danger] = "Failed to create activity entry!"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @activity.update(params_activity)
      flash[:success] = "Activity entry updated!"
      redirect_to @activity
    else
      flash[:danger] = "Failed to update activity!"
      render 'edit'
    end
  end

  def destroy
    @activity.destroy
    flash[:success] = "Activity entry deleted!"
    redirect_to activities_path
  end

  private

  def params_activity
    params.require(:activity).permit(:name)
  end

  def find_activity
    @activity.find(params[:id])
  end
end
