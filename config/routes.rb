# frozen_string_literal: true

Rails.application.routes.draw do
  get 'search', to: 'search#index'
  get 'home/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root to: 'home#index'
  resources :recipes
  resources :steps, only: %i[new create]
  resources :ingredients, only: %i[new create]
  resources :recipe_ingredients, only: %i[new create]
  resources :users, only: [:show]
  resources :plans do
    collection do
      get :new_recipe
      post :add_recipe
    end
    member do
      delete :remove_recipe
    end
  end
  resources :shopping_lists, only: %i[show update]
  resources :shopping_list_ingredients, only: %i[new create]
  resources :favourite_recipes, only: %i[index create destroy]
  get 'generate_pdf', to: 'pdf_generator#generate_pdf'

  get 'tags/:tag', to: 'recipes#index', as: :tag
end
