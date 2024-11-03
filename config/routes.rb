Rails.application.routes.draw do
  get "goals/new"
  get "goal/new"
  get "static_pages/home"
  root "static_pages#home"

  # Good Job Dashboard
  mount GoodJob::Engine => "good_job"

  # health check
  get "up" => "rails/health#show", as: :rails_health_check

  resources :goals do
    collection do
      get 'add_initial_state_goal_rules', to: 'goals#add_initial_state_goal_rule', as: :add_initial_state_goal_rules
      get 'add_end_state_goal_rules', to: 'goals#add_end_state_goal_rule', as: :add_end_state_goal_rules
    end
  end

  namespace :api do
    namespace :v1 do
      post "people", to: "people#create"
      post "events", to: "events#create"
    end
    resources :goals
  end

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
