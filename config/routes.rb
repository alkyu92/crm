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
  get '/opportunities/:opportunity_id/stages/:id/update_stage_status',
  to: 'stages#update_stage_status', as: :update_stage_status

  root 'dashboards#index'
end
