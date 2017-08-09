Rails.application.routes.draw do

  devise_for :users

  resources :dashboards
  resources :opportunities do

    get '/delete_attachment/:id',
    to: 'opportunities#delete_attachment', as: :delete_attachment

    resources :timelines
    resources :stages
    resources :tasks
    resources :calls
    resources :events
    resources :notes
  end
  resources :contacts
  resources :accounts
  resources :users

  get '/search', to: 'search#search', as: :search

  get '/opportunities/:opportunity_id/stages/:id/update_stage_status',
  to: 'stages#update_stage_status', as: :update_stage_status

  get '/opportunities/:opportunity_id/tasks/:id/update_task_status',
  to: 'tasks#update_task_status', as: :update_task_status

  get '/opportunities/:opportunity_id/events/:id/update_event_status',
  to: 'events#update_event_status', as: :update_event_status

  root 'dashboards#index'
end
