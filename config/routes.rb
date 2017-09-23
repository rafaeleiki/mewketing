Rails.application.routes.draw do

  root 'home#index'
  mount API => '/'

  resources :emails
  resources :templates
  resources :groups
  resources :receivers
  get '/senders/not_user' => 'senders#not_user'
  resources :senders
  resources :clients

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/not_admin' => 'sessions#not_admin'
end
