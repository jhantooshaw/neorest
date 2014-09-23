Rails.application.routes.draw do
  #devise_for :clients
  
  
  
  constraints(ClientSubdomain) do
    devise_for :clients,  :path_names => {:sign_in => 'login', :sign_out => 'logout' }, :controllers => {:sessions => "clients/sessions", 
      :registrations => "clients/registrations"}
    
    devise_scope :client do
      get "valid-client/:token" => "clients/sessions#valid_client", :as => :valid_client
    end
    
    authenticated :client do
      as :client do
        root :to => 'clients/clients#index', :as => :client 
        namespace :clients do            
          match 'import-loc-fin-year' => 'clients#location_financial_year',         :as => :loc_fin_year,        :via => [:post]       
          match 'save-loc-fin-year'   => 'clients#save_location_financial_year',    :as => :save_loc_fin_year,   :via => [:post]  
          match 'set-loc-fin-year'    => 'clients#set_location_financial_year',     :as => :set_loc_fin_year,    :via => [:post]  
          match 'import-master'       => 'imports#import_master',                   :as => :import_master,       :via => [:get, :post]           
          
          resources :reports, only: [:index] do
            collection do
              match 'frs-report'          => 'reports#frs_report',                  :via => [:get, :post]
              match 'product-wise-sale'   => 'reports#product_wise_sale',           :via => [:get, :post]
              match 'sale'                => 'reports#sale',                        :via => [:get, :post]
              match 'login'               => 'reports#login',                       :via => [:get, :post]
              match 'void-bills'          => 'reports#void_bills',                  :via => [:get, :post]
              match 'item-canceled'       => 'reports#item_canceled',               :via => [:get, :post]
            end
          end
        end
        
        scope :module => "clients" do
          match 'transaction'         => 'imports#transaction',                     :as => :import_transaction,       :via => [:get, :post] 
        end
        
       
      end
    end  
  end
  
  match 'check-subdomain' => 'welcome#check_subdomain', :as => :valid_subdomain, :via => :get
  match 'get-locations/:id'    => 'welcome#get_locations', :as => :locations, :via => :get
  match 'get-outlets/:id'    => 'welcome#get_outlets', :as => :outlets, :via => :get
  match 'get-response'    => 'welcome#get_response', :as => :get_response, :via => :get
  

  
  root 'welcome#index'
  #root 'clients/sessions#new'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  

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
  
  # custom path for propagating all errors
  match "*path", :to => "exceptions#show", via: :all
end
