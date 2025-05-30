Rails.application.routes.draw do
  root "posts#index"
  resources :posts do
    resource :favorite, only: [:create, :destroy]
    collection do
      get 'ranking'
    end
  end

  
  get 'maps', to: 'maps#index'
  get 'users/favorites', to: 'users#favorites', as: 'user_favorites'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

end
