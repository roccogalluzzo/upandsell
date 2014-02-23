Upandsell::Application.routes.draw do
  devise_for :customers

  root 'site#index'
  #product page
  get '/p/:slug' => 'products#show'
  get 'products/success' => 'products#success'
  post 'products/ipn' => 'products#ipn'
  get 'download/p/:token' => 'products#download', :as => 'download_product'

  resources :products  do
   get 'buy',  on: :member
 end

 namespace :user do
  root 'products#summary'
    # Settings
    get 'settings/account' => 'settings#account'
    get 'settings/payments' => 'settings#payments'
    patch 'settings/update_account' => 'settings#update_account'
    patch 'settings/update_payments' => 'settings#update_payments'
    post '/products/upload' => 'products#upload'
    get '/products/upload_request' => 'products#upload_request'
    resources :products
    resources :payments do
     get 'refund', on: :member
   end
 end
end
