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
    # Settings
    get 'settings/account' => 'settings#account'
    get 'settings/password' => 'settings#password'
    get 'settings/payments' => 'settings#payments'
    get 'settings/setup' => 'settings#setup'
    get 'settings/upgrade' => 'settings#upgrade'
    post 'settings/upgrade' => 'settings#save_upgrade'
    get 'settings/resend_email' => 'settings#resend_email'
    patch 'settings/update_email' => 'settings#update_email'
    patch 'settings/update_account' => 'settings#update_account'
    patch 'settings/update_password' => 'settings#update_password'
    post 'settings/update_payments' => 'settings#update_payments'
    get 'settings/update_cc_token' => 'settings#paymill_refresh'
    get 'settings/add_paypal' => 'settings#add_paypal'
    get 'settings/add_paypal_callback' => 'settings#add_paypal_callback'
    root 'products#summary'
    post 'products/files'  => 'products#files'
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
