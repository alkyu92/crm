Rails.application.routes.draw do

  devise_for :users

  resources :dashboards

  resources :opportunities do

    resources :contacts do
      resources :relationships, only: :destroy
    end

    get '/delete_attachment/:id',
    to: 'opportunities#delete_attachment', as: :delete_attachment
    resources :timelines

    resources :stages do
      member do
        get '/update_status', to: 'stages#update_stage_status'
      end
    end

    resources :tasks do
      member do
        get '/update_task_status', to: 'tasks#update_task_status'
      end
    end

    resources :calls

    resources :events do
      member do
        get '/update_event_status', to: 'events#update_event_status'
      end
    end

    resources :notes
  end

  resources :accounts do

    resources :contacts do
      resources :relationships, only: :destroy
    end

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
  resources :contacts
  resources :relationships, only: :destroy

  get '/search', to: 'search#search', as: :search

  get '/timelines/:id', to: 'timelines#update_read_status', as: :update_read_status

  root 'dashboards#index'
  get "*path" => redirect("/")
end
