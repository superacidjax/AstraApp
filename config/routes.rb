Rails.application.routes.draw do
  get "static_pages/home"
  root "static_pages#home"

  # Good Job Dashboard
  mount GoodJob::Engine => "good_job"

  # health check
  get "up" => "rails/health#show", as: :rails_health_check

  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        post "people", to: "people#create"
        post "events", to: "events#create"
      end
    end
  end

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
