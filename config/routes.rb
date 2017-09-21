Rails.application.routes.draw do

  root 'home#index'
  mount API => '/'

  resources :emails
  resources :templates
  resources :groups
  resources :receivers
  resources :senders
  resources :clients

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
end
