Upandsell::Application.routes.draw do
  devise_for :users

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
    patch 'settings/update_account' => 'settings#update_account'
    patch 'settings/update_password' => 'settings#update_password'
    patch 'settings/update_payments' => 'settings#update_payments'
    get 'settings/update_cc_token' => 'settings#paymill_refresh'
    get 'settings/add_paypal_refund' => 'settings#add_paypal_refund'
    get 'settings/add_paypal_refund_callback' => 'settings#add_paypal_refund_callback'
    root 'products#summary'
    get 'products/upload_request'  => 'products#upload_request'
    get 'products/metrics'  => 'products#metrics'
    resources :products, except: [:show] do
      post 'upload'
      get 'share',  on: :member
    end
    resources :orders, only: [:index, :show] do
     get 'refund', on: :member
   end
 end
end
