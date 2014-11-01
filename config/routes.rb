Rails.application.routes.draw do
  get 'drink/index'

  get   'lottery/index'


  get   'top/index'


  get   'lottery/statistic/:type' => 'lottery#statistic'
  get   'lottery/newest/:type'    => 'lottery#newest'
  post  'lottery/new'             => 'lottery#new'
  get   'lottery/:type/:page'     => 'lottery#index'
  get   'lottery/refresh'         => 'lottery#refresh'

  get   'lotterystatistic/count/:type' => 'lottery_statistic#count'
  

  post  'weather/update'        => 'weather#update'


  get   'drink/index'           => 'drink#index'
  post  'drink/update'          => 'drink#update'


  get   'foodmenu/index/:type'  => 'food_menu#index'
  post  'foodmenu/update/:type' => 'food_menu#update'
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'top#index'


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
