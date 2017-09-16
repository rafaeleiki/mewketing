Rails.application.routes.draw do

  resources :emails
  resources :templates
  resources :groups
  resources :receivers
  resources :senders
  resources :clients
  mount API => '/'

  root 'home#index'

end
