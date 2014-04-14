require 'sidekiq/web'


Upandsell::Application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations',
    registrations: "registrations" }
    mount Sidekiq::Web => '/sidekiq'
    root 'landing#index'
    get 'privacy' => 'site#privacy'
    get 'terms' => 'site#terms'
  #product page
  get '/p/:slug' => 'products#show', :as => 'product_slug'
  get 'products/paypal' => 'products#paypal'
  get 'products/pay_info' => 'products#pay_info'
  post 'products/pay' => 'products#pay'
  get 'products/check_payment' => 'products#check_paypal_payment'
  post 'products/ipn' => 'products#ipn'
  get 'download/p/:token' => 'products#download', :as => 'download_product'

  resources :products, only: [:show]  do
   #get 'paypal',  on: :member
 end

 namespace :user do
    # Settings
    get 'settings/account' => 'settings#account'
    get 'settings/payments' => 'settings#payments'
    get 'settings/setup' => 'settings#setup'
    get 'settings/resend_email' => 'settings#resend_email'
    patch 'settings/update_email' => 'settings#update_email'
    patch 'settings/update_account' => 'settings#update_account'
    patch 'settings/update_password' => 'settings#update_password'
    post 'settings/update_payments' => 'settings#update_payments'
    get 'settings/update_cc_token' => 'settings#paymill_refresh'
    get 'settings/add_paypal' => 'settings#add_paypal'
    get 'settings/add_paypal_callback' => 'settings#add_paypal_callback'
    root 'products#summary'
    get 'products/upload_request'  => 'products#upload_request'
    post 'products/file_changed'  => 'products#file_changed'
    get 'products/metrics'  => 'products#metrics'
    resources :products, except: [:show] do
      post 'upload'
      get 'toggle_published',  on: :member
    end
    resources :orders, only: [:index, :show] do
     get 'refund', on: :member
   end
 end
end
