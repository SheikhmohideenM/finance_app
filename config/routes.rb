Rails.application.routes.draw do
  root "sessions#new"

  get "transactions/index"
  get "transactions/new"
  post "transactions/create"
  delete "transactions/destroy"

  get "categories/index"
  get "categories/new"
  post "categories/create"

  get "accounts/index"
  get "accounts/new"
  post "accounts/create"
  delete "accounts/destroy"

  # Authentication
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/dashboard", to: "dashboard#index"

  namespace :api do
    namespace :v1 do
      resources :budgets
      resources :pots
      resources :transactions
      resources :categories
      resources :accounts
    end
  end


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
