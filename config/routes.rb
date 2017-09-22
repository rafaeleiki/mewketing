Rails.application.routes.draw do

  root 'home#index'
  mount API => '/'

  resources :emails
  resources :templates
  resources :groups
<<<<<<< Updated upstream
  resources :receivers
=======
  resources :receivers do
    get :add_to_group_show, on: :member
  end
>>>>>>> Stashed changes
  resources :senders
  resources :clients

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
end
