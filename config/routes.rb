# frozen_string_literal: true

Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'password_resets/create'
  get 'password_resets/update'
  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/help'
  resources :static_pages, only: %i[home help]

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :account_activations, only: :edit
end
