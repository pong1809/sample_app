# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/help'
  resources :static_pages, only: %i[home help]

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users, only: :show
end
