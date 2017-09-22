Rails.application.routes.draw do

  root 'home#index'
  mount API => '/'

  resources :emails
  resources :templates
  resources :groups
  resources :receivers
  resources :senders do
    get :not_user, on: :collection
  end
  resources :clients

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/not_admin' => 'sessions#not_admin'
end
