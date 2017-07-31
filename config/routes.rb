Rails.application.routes.draw do

  devise_for :users

  resources :dashboards
  resources :opportunities do
    resources :stages
  end
  resources :activities
  resources :contacts

  resources :users

  get '/search', to: 'search#search', as: :search

  root 'dashboards#index'
end
