Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :users, :only => [:show]
  get "/" => 'users#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
