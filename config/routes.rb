Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  root 'home#index'
  resources :users, :only => [:show, :create, :update, :destroy]
  resources :sessions, :only => [:create, :destroy]
  resources :feeds, :only => [:show, :create, :destroy]
  resources :articles, :only => [:show, :update, :read]
  resources :folders, :only => [:create]
  post "/signup" => 'users#create'
  post "/sessions" => 'sessions#create'
  delete "/sessions" => 'sessions#destroy'
  get "/feeds" => 'feeds#show'
  get "/articles" => 'articles#show'
  patch "/articles" => 'articles#update'
  patch "/articles-read" => 'articles#read'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
