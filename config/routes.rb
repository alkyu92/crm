Rails.application.routes.draw do

  devise_for :users

  resources :dashboards

  resources :opportunities do
    resources :contacts
    get '/delete_attachment/:id',
    to: 'opportunities#delete_attachment', as: :delete_attachment
    resources :timelines
    resources :stages
    resources :tasks
    resources :calls
    resources :events
    resources :notes
  end

  resources :accounts do
    resources :contacts
    get '/delete_attachment/:id',
    to: 'accounts#delete_attachment', as: :delete_attachment
    resources :timelines
    resources :notes
    resources :opportunities
  end

  get '/tasks', to: 'tasks#index'
  get '/calls', to: 'calls#index'
  get '/contacts', to: 'contacts#index'
  get '/events', to: 'events#index'
  get '/notifications', to: 'notifications#index'

  resources :users

  get '/search', to: 'search#search', as: :search

  get '/opportunities/:opportunity_id/stages/:id/update_stage_status',
  to: 'stages#update_stage_status', as: :update_stage_status

  get '/opportunities/:opportunity_id/tasks/:id/update_task_status',
  to: 'tasks#update_task_status', as: :update_task_status

  get '/opportunities/:opportunity_id/events/:id/update_event_status',
  to: 'events#update_event_status', as: :update_event_status

  get '/timelines/:id', to: 'timelines#update_read_status', as: :update_read_status

  root 'dashboards#index'
  get "*path" => redirect("/")
end
