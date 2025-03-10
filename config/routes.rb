Rails.application.routes.draw do
  resources :board_games do
    collection do
      get "scan", to: "board_games#scan", as: "board_games_scan"
      post "scan", to: "board_games#create"
    end
    resources :borrowings, only: [ :create, :new ]
  end
  devise_for :users
  resources :users do
    resources :games, only: [ :index ]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
