Upandsell::Application.routes.draw do
  devise_for :customers

  root 'site#index'
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
    patch 'settings/update_payments' => 'settings#update_payments'
    root 'products#summary'
     get 'products/upload_request'  => 'products#upload_request'
    resources :products, except: [:show] do
      post 'upload'
    end
    resources :payments, only: [:index, :show] do
     get 'refund', on: :member
   end
 end
end
