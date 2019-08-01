Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :users, :only => [:show, :create, :update, :destroy]
  resources :sessions, :only => [:create, :destroy]
  post "/signup" => 'users#create'
  post "/login" => 'sessions#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
