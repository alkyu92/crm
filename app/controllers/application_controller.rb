class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :devise_params, if: :devise_controller?
  after_action :store_location

  def timeline_account(nactivity, action)
    @account.timelines.create!(
    nactivity: nactivity,
    action: action,
    user_id: current_user.id
    )
  end

  def timeline_opportunity(nactivity, action)
    @opportunity.timelines.create!(
    nactivity: nactivity,
    action: action,
    user_id: current_user.id
    )
  end

  def timeline_task(action)
    @opportunity.timelines.create!(
    nactivity: @task.description.truncate(50),
    action: action,
    user_id: current_user.id
    )
  end

  def timeline_call(action)
    @opportunity.timelines.create!(
    nactivity: @call.description.truncate(50),
    action: action,
    user_id: current_user.id
    )
  end

  def timeline_event(action)
    @opportunity.timelines.create!(
    nactivity: @event.description.truncate(50),
    action: action,
    user_id: current_user.id
    )
  end

  def timeline_note(action)
    @subject.timelines.create!(
    nactivity: @note.title,
    action: action,
    user_id: current_user.id
    )
  end

  protected
  def devise_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar,
                                                              :phone, :title,
                                                              :address, :department])
  end

  def store_location
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
