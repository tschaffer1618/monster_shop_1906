Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "welcome#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  namespace :merchant do
    get "/", to: "dashboard#index", as: :user
    # get "/orders", to: "dashboard#index", as: :orders_show
    # get "/orders", to: "dashboard#show", as: :orders_show
    resources :orders, only: [:show]
    resources :items, only: [:index, :destroy], as: :user
  end

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:new, :create] do
    resources :reviews, except: [:show, :index]
  end

  resources :orders, only: [:new, :create, :show]

  namespace :admin do
    get "/", to: "dashboard#index"
    resources :users, only: [:index, :show]
    resources :merchants, only: [:show]
  end

  patch "/merchant/:order_id/:item_order_id/fulfill", to: "merchant/orders#fulfill"

  patch "/merchants/:id/update_status", to: "merchants#update_status"

  get "/register", to: "users#new"
  post "/register", to: "users#create"

  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/edit_password", to: "users#edit_password"
  patch "/profile/update_password", to: "users#update_password"
  get "/profile/orders", to: "users#show_orders"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/:increment_decrement", to: "cart#increment_decrement"
end
