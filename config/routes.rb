Rails.application.routes.draw do

  devise_for :users

  resources :dashboards
  resources :opportunities
  resources :activities
  resources :contacts
  resources :users

  root 'dashboards#index'
end
