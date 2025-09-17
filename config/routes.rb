Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "home#index"

  resources :groups, only: %i[new show create edit]
  resources :expenses, only: %i[show new]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balan cers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api, defaults: { format: :json } do
    resources :expenses, only: %i[create update destroy]
    resources :groups, only: %i[create]
    resources :settlements, only: %i[create]
  end
end
