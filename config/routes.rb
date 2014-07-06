require 'sidekiq/web'


Upandsell::Application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations', registrations: "registrations" }

  get '/auth/paypal' => 'user/settings/payments#paypal_connect', as: 'paypal_integration'
  get '/auth/paymill/callback' => 'user/settings/payments#paymill_callback', as: 'paymill_integration_callback'
  get '/auth/paypal/callback' => 'user/settings/payments#paypal_callback', as: 'paypal_integration_callback'
  get '/auth/:provider/callback' => 'user/settings/integrations#create', as: 'integration_callback'

 # Front-end
 root 'landing#index'
 get 'pricing' => 'site#pricing'
 get 'privacy' => 'site#privacy'
 get 'terms' => 'site#terms'

 # subscriptions emails
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

  resources :affiliations
  resources :products, except: [:show] do
    post 'upload'
    get 'toggle_published',  on: :member
  end

  resources :orders, only: [:index] do
   get 'refund', on: :member
 end

 namespace :tools do
  resources :coupons, except: [:new]
  resources :serial_keys, except: [:new]
  resources :mailing_lists do
    get 'sync', on: :member
    post 'create_sync', on: :member
    post 'remove_sync', on: :member
    get 'search', on: :collection
    post 'send_email', on: :member
    post 'send_test_email', on: :member
  end
end

root 'products#summary'
get 'setup', to: 'setup#index'
get 'resend_email', to: 'setup#resend_email'
patch 'update_email', to: 'setup#update_email'

post 'products/files'  => 'products#files'

get 'products/metrics'  => 'products#metrics'

namespace :settings do
  resources :webhooks, except: [:new]
  resource :account, only: [:edit, :update]
  resource :payments, only: [:edit, :update] do
    get 'connect'
    get 'connect_callback'
  end
  resource :integrations, only: [:edit, :create]
  resource :emails, only: [:edit, :update]
  resource :upgrade, only: [:edit, :update]
end

end
end
