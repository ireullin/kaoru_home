Rails.application.routes.draw do

  get 'money_note' => 'money_note#index'
  get 'money_note/history/:year/:month' => 'money_note#history'
  get 'money_note/rate/:year/:month' => 'money_note#rate'
  post 'money_note/create'
  post 'money_note/items'

  get 'movie/index'
  get 'movie/reserve'
  get 'movie/theater'     => 'movie#theater'
  get 'movie/theater/:id' => 'movie#theater'
  get 'movie/schedule/:id' => 'movie#schedule'
  post 'movie/update_schedules'
  post 'movie/create'
  post 'movie/delete'


  get  'logger/index'
  get  'logger/history/:page' => 'logger#history'
  get  'logger/varify/:page' => 'logger#varify_password_history'
  
  get 'photo_album/photoset/:path' => 'photo_album#index'
  get 'photo_album/manage'
  get 'photo_album/new'
  post 'photo_album/create'
  post 'photo_album/update'
  post 'photo_album/delete/:path' => 'photo_album#delete'
  get 'photo_album/edit/:path' => 'photo_album#edit'

  get   'top/index'
  get   'top/login'
  post  'top/varify'
  get   'top/logout'
  get   'top/first'
  post  'top/record_name'


  get   'lottery/history/:type/:page'   => 'lottery#index'
  get   'lottery/statistic/:type'       => 'lottery#statistic'
  get   'lottery/bubblechart/:type'     => 'lottery#bubble_chart'
  get   'lottery/newest/:type'          => 'lottery#newest'
  post  'lottery/new'                   => 'lottery#new'
  

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
