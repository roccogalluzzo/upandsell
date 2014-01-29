Upandsell::Application.routes.draw do
  devise_for :customers
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'site#index'
  #product page
  get '/p/:slug' => 'products#show'
  # Example of regular route:
  get 'products/success' => 'products#success'
  post 'products/ipn' => 'products#ipn'
  get 'download/p/:token' => 'products#download', :as => 'download_product'
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :products  do
   get 'buy',  on: :member
 end
 resources :customers
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  namespace :customer do
    # Settings
    get 'settings/account' => 'settings#account'
    get 'settings/payments' => 'settings#payments'
    patch 'settings/update_account' => 'settings#update_account'
    patch 'settings/update_payments' => 'settings#update_payments'
    post '/products/upload' => 'products#upload'
    resources :products
    resources :payments do
     get 'refund', on: :member
   end
   root :to => "products#index"

 end
end
