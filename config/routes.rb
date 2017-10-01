Rails.application.routes.draw do

  root 'home#index'
  mount API => '/'

  resources :emails do
    get :not_email, on: :collection
    get :groups, on: :member
  end
  resources :templates do
    get :not_template, on: :collection
  end
  resources :groups do
    get :not_group, on: :collection
    get :receivers, on: :member
  end
  resources :receivers do
    get :add_to_group_show, on: :member
    get :access_denied, on: :collection
  end

  resources :senders do
    get :not_user, on: :collection
    get :not_admin, on: :collection
    get :not_client, on: :collection
  end
  resources :clients do
    get :not_client, on: :collection
  end

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/not_admin' => 'sessions#not_admin'
end
