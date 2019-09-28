Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "welcome#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  patch "/cart/addresses/:address_id/add", to: "sessions#add_address"

  get "/profile/orders/:order_id/change_address", to: "orders#change_address"
  patch "/profile/orders/:order_id/:address_id/update_address", to: "orders#update_address"

  namespace :merchant do
    get "/", to: "dashboard#index", as: :user
    resources :orders, only: [:show]
    get "/orders/:id", to: "dashboard#show", as: :orders_show
    resources :items, as: :user
  end

  patch "/merchant/items/:item_id/update_status", to: "merchant/items#update_status"

  resources :merchants do
    resources :items, only: [:index]
  end

  resources :items, except: [:new, :create] do
    resources :reviews, except: [:show, :index]
  end

  patch "/orders/:id", to: "orders#cancel", as: :order_cancel

  namespace :admin do
    get "/", to: "dashboard#index"
    patch "/orders/:order_id/update_status", to: "dashboard#update_status"

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

  scope path: 'profile' do
    get '/addresses', to: "addresses#new", as: :profile_addresses
    resources :addresses, except: [:new, :index]
    resources :orders, only: [:create, :new]
  end

  get "/profile/orders/:id", to: "users#show_order"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/:increment_decrement", to: "cart#increment_decrement"
end
