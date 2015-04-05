OpenansCom::Application.routes.draw do
  root :to => 'home#index'  
  resources :qus
  resources :ans
  resources :options
  resources :ques_views
  match "/get-next-qus" => "home#get_next_qus", :as => :get_next_qus
  match "/get-notification/:uid" => "home#get_notification", :as => :get_notification
  match "/how-to-use" => "home#how_to", :as => :how_to
  match "/terms" => "home#terms", :as => :terms
  match "/privacy" => "home#privacy", :as => :privacy
  match "/ask" => "home#ask", :as => :ask
  match "/create-like" => "home#create_like", :as => :create_like
  match "/show-profile" => "home#show_profile", :as => :show_profile
  match "/keep-profile/:id" => "home#keep_profile", :as => :keep_profile
  match "/change-expire-setting/:id" => "home#change_expire", :as => :change_expire
  match "/submit-qu" => "home#submit_qu", :as => :submit_qu
  match "/submit-ans/:id" => "home#submit_ans", :as => :submit_ans
  get 'sitemap.xml', :to => 'home#sitemap', :defaults => { :format => 'xml' }, :conditions => { :method => :get }, :as => :sitemap
  match "/feed/all" => "home#qu_rss", :as => :qu_rss
  match "/search-qu" => "home#search", :as => :search

  match "/trending" => "home#trending", :as => :trending
  match "/latest" => "home#latest", :as => :latest
  match "/most-liked" => "home#most_liked", :as => :most_liked
  match "/most-unliked" => "home#most_unliked", :as => :most_unliked
  match "/unanswered" => "home#unanswered", :as => :unanswered
  match "/activities" => "home#activity", :as => :activity
  match "/contact" => "home#contact", :as => :contact
  match "/stat" => "home#stat", :as => :stat
  match "/how-to-get-notification" => "home#how_notify", :as => :how_notify
  match "/testing" => "qus#testing", :as => :testing

  match "/:id" => "home#answer", :as => :answer

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
