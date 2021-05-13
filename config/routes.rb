require 'sidekiq/web'

Rails.application.routes.draw do
  root to: "profiles#show"
  scope :api, defaults: { format: 'json' } do
    devise_for :users, :controllers => { :invitations => 'invitations' }

    get :track_event, to: 'track_events#create'

    resources :worklogs, only: [:index]
    resources :dashboards, only: [:index]

    resources :users, only: [:index, :show, :update] do
      post 'search', on: :collection
      get 'reported', on: :collection, to: 'users/update_reports#index'

      namespace :users, path: nil do
        resources :links, only: [:index, :update, :create, :destroy]
        resources :skills, only: [:index, :destroy]
        resources :skill_updates, only: [:create, :update]
        resources :achievements, only: [:index] do
          put 'set_favorite', on: :member
        end
        post :bulk_skill_updates, to: 'skill_updates#bulk_create'
      end

      member do
        get :timegraph
        get :stats
        get :day_info
        get :worktime, to: 'users/worktime#show'
        get :worktime_by_projects, to: 'users/worktime#by_projects'
      end
    end
    resources :users, only: [], param: :token do
      namespace :users, path: nil do
        resource :invitation, only: [:show, :update]
      end
    end
    resource :profile, only: [:show, :update, :edit] do
      put 'update_avatar', on: :member
    end

    resources :updates, only: [:index, :show, :create, :update]
    resources :timings, only: [:index]
    resources :skills, only: [:index, :create] do
      post 'search', on: :collection
    end

    resources :difficulty_levels, only: [:index, :create, :update, :destroy]
    resources :notifications, only: [:index, :create] do
      post :read, on: :member
      post :read_all, on: :collection
    end
    resources :events, only: [:index, :show, :create, :update, :destroy] do
      post :approve, on: :member
      post :disapprove, on: :member
    end

    resources :skill_types, only: :index

    namespace :reports do
      get 'service_load', to: 'service_load#index'
      get 'timesheet', to: 'timesheet#index'
    end

    resources :faq, only: [:index, :show]

    namespace :integration do
      scope :discord do
        get '/' => 'discord#connect'
        get 'callback' => 'discord#callback', as: :discord_callback
        get 'disconnect' => 'discord#disconnect'
      end
      scope :slack do
        get '/' => 'slack#connect'
        get 'callback' => 'slack#callback', as: :slack_callback
        get 'disconnect' => 'slack#disconnect'
        post 'action' => 'slack#action'
        post 'slash' => 'slack#slash'
        post 'event' => 'slack#event'
      end
      scope :timedoctor do
        get '/' => 'timedoctor#connect'
        get 'callback' => 'timedoctor#callback', as: :timedoctor_callback
        get 'disconnect' => 'timedoctor#disconnect'
      end
    end
    namespace :admin do
      resources :users, only: [:index, :destroy, :edit, :update, :create] do
        get 'restore' => 'users#restore', on: :member
        get 'count' => 'users#count', on: :collection
        get 'count_average' => 'users#count_average', on: :collection
        get 'updates' => 'users#updates_report', on: :collection
        get 'without_updates' => 'users#without_updates', on: :collection
        post :impersonate, on: :member
        post :stop_impersonating, on: :collection
      end
      resources :skill_types, only: [:index, :show, :create, :update, :destroy]
      resources :skills, only: [:index, :create, :update, :destroy]
      resources :steps, only: [:index, :create, :update, :destroy] do
        get :integrations, on: :collection
      end
      resources :achievements, only: [:index, :show, :create, :update, :destroy] do
        get :counters, on: :collection
      end
      resources :invitations, only: [:index, :create, :show, :update, :destroy]
      resources :sections, only: [:index, :create, :update, :destroy]
      resources :answers, only: [:index, :create, :update, :destroy]
      resources :questions, only: [:index, :create, :update, :destroy]
    end
    resources :roles, only: %i[index show create update destroy]
    resources :onboardings, only: [:show, :update]
    resources :permissions, only: %i[index]
    resources :holidays, only: %i[index create update destroy]
    namespace :plans do
      get :people
      get :managers
      get :projects
    end
  end

  # ActiveAdmin.routes(self)

  mount Sidekiq::Web => '/sidekiq'

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
