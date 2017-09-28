Rails.application.routes.draw do

  root 'home#index'
  mount API => '/'

  resources :emails
  resources :templates
  resources :groups
  resources :receivers do
    get :add_to_group_show, on: :member
    get :access_denied, on: :collection
  end
  resources :senders do
    get :not_user, on: :collection
    get :not_admin, on: :collection
  end
  resources :clients do
    get :access_denied, on: :collection
  end

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/not_admin' => 'sessions#not_admin'
end
