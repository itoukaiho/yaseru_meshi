# frozen_string_literal: true

Rails.application.routes.draw do
  root 'posts#index'
  resources :posts do
    resource :favorite, only: %i[create destroy]
    collection do
      get 'ranking'
    end
  end

  get 'maps', to: 'maps#index'
  get 'users/favorites', to: 'users#favorites', as: 'user_favorites'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in', as: :guest_sign_in
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    resources :posts, only: [] do
      member do
        post :generate_advice
      end
    end
  end
end
