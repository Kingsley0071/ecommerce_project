Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get "cart_items/create"
  get "cart_items/update"
  get "cart_items/destroy"
  get "carts/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get '/about', to: 'pages#show', defaults: { id: 'about' }
  get '/contact', to: 'pages#show', defaults: { id: 'contact' }

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Create a Stripe Checkout Route and Controller Action
  post 'create_checkout_session', to: 'orders#create_checkout_session'
  post 'cart/create_checkout_session', to: 'carts#create_checkout_session', as: :cart_create_checkout_session
  
  # config/routes.rb
  post 'stripe/webhook', to: 'stripe_webhooks#create'

  # Defines the root path route ("/")
  root "products#index"

  # Enable full RESTful routes for products (including edit, update, destroy, new, create)
  resources :products

  resources :categories, only: [:index, :show]
  resource :cart, only: [:show]
  resources :pages, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy], param: :id
  resources :orders, only: [:new, :create, :show, :index, :update]

  resources :orders do
    post :create_checkout_session, on: :collection
  end
end