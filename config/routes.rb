Upandsell::Application.routes.draw do
  devise_for :customers

  root 'site#index'
  #product page
  get '/p/:slug' => 'products#show'
  get 'products/success' => 'products#success'
  post 'products/ipn' => 'products#ipn'
  get 'download/p/:token' => 'products#download', :as => 'download_product'

  resources :products, only: [:show]  do
   get 'buy',  on: :member
 end

 namespace :user do
    # Settings
    get 'settings/account' => 'settings#account'
    get 'settings/payments' => 'settings#payments'
    patch 'settings/update_account' => 'settings#update_account'
    patch 'settings/update_payments' => 'settings#update_payments'
    root 'products#summary'
    resources :products, except: [:show] do
      post 'upload'
      get 'upload_request'
    end
    resources :payments, only: [:index, :show] do
     get 'refund', on: :member
   end
 end
end
