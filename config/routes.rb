Rails.application.routes.draw do

  devise_for :users

  resources :dashboards
  resources :opportunities
  resources :activities
  resources :users

  get '/search', to: 'search#search', as: :search

  root 'dashboards#index'
end
