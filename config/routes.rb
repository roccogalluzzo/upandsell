require 'sidekiq/web'


Upandsell::Application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations',
    registrations: "registrations" }

    root 'landing#index'
    get 'pricing' => 'site#pricing'
    get 'privacy' => 'site#privacy'
    get 'terms' => 'site#terms'
    get 'unsubscribe/u/:user/:type/:signature' => 'emails#unsubscribe_user',
    :as => 'unsubscribe_user'
    get 'confirm_unsubscribe/u/:user/:type/:signature' => 'emails#confirm_unsubscribe_user',
    :as => 'confirm_unsubscribe_user'

    get 'unsubscribe/o/:order/:signature' => 'emails#unsubscribe_order',
    :as => 'unsubscribe_order'
    get 'confirm_unsubscribe/o/:order/:signature' => 'emails#confirm_unsubscribe_order',
    :as => 'confirm_unsubscribe_order'
    get 'unsubscribed' => 'emails#unsubscribed'

  #product page
  get '/p/:slug' => 'products#show', :as => 'product_slug'

  #checkout
  post 'checkout/paypal' => 'checkouts#paypal'
  get 'checkout/pay_info' => 'checkouts#pay_info'
  post 'checkout/pay' => 'checkouts#pay'
  get 'checkout/check_payment' => 'checkouts#check_paypal_payment'
  post 'checkout/ipn' => 'checkouts#ipn'
  get 'download/p/:token' => 'products#download', :as => 'download_product'

  resources :products, only: [:show]  do
   #get 'paypal',  on: :member
 end

 namespace :admin do
   mount Sidekiq::Web => 'sidekiq'
   root 'admin#summary'
 end

 namespace :user do
  get 'setup',    to: 'setup#index'
  get 'resend_email',to: 'setup#resend_email'
  patch 'update_email', to: 'setup#update_email'
  namespace :settings do
    get 'account'
    get 'password'
    get 'upgrade'
    get 'payments'
    get 'connect'
    get 'connect_callback'
    get 'add_paypal_callback', to: 'settings#add_paypal_callback'

    post 'upgrade', to: 'settings#save_upgrade'
    post 'update_payments', to: 'settings#update_payments'
    patch 'update_account', to: 'settings#update_account'
    patch 'update_password', to: 'settings#update_password'
  end
  root 'products#summary'
  post 'products/files'  => 'products#files'

  get 'products/metrics'  => 'products#metrics'
  resources :products, except: [:show] do
    post 'upload'
    get 'toggle_published',  on: :member
  end
  resources :orders, only: [:index, :show] do
   get 'refund', on: :member
 end
 resources :affiliations
end
end
