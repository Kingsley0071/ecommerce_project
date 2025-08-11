Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  get "cart_items/create"
  get "cart_items/update"
  get "cart_items/destroy"
  get "carts/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get "up" => "rails/health#show", as: :rails_health_check

  # Add a direct route for the about page
  get "/about", to: "pages#about"
  get "/contact", to: "pages#show", defaults: { id: "contact" }

  post "create_checkout_session", to: "orders#create_checkout_session"
  post "cart/create_checkout_session", to: "carts#create_checkout_session", as: :cart_create_checkout_session
  post "stripe/webhook", to: "stripe_webhooks#create"

  root "products#index"

  resources :products
  resources :categories, only: [ :index, :show ]
  resource :cart, only: [ :show ]
  resources :pages, only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ], param: :id
  resources :orders, only: [ :new, :create, :show, :index, :update ]

  resources :orders do
    post :create_checkout_session, on: :collection

  resources :products do
  resources :comments, only: [:create, :edit, :update, :destroy]  
  end
end