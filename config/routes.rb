Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root "application#welcome"

  get "/register", to: "users#new"
  get "/users/:user_id", to: "users#dashboard"
  get "/users/:user_id/discover", to: "movies#discover"
  get "/users/:user_id/movies", to: "movies#index"
  get "/user_parties/create", to: "user_parties#create"

  resources :users, only: [:create]

  resources :users, only: [:show] do
    resources :movies, only: [:show] do
      resources :parties, only: [:new, :create]
    end
  end

  get "/login", to: "users#login_form"
  post '/login', to: 'users#login_user'
end
