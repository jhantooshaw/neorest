Rails.application.routes.draw do
  #devise_for :clients
  
  
  
  constraints(ClientSubdomain) do
    devise_for :clients,  :path_names => {:sign_in => 'login', :sign_out => 'logout' }, :controllers => {:sessions => "clients/sessions", 
      :registrations => "clients/registrations", :passwords => "clients/passwords"}
    
    devise_scope :client do
      get "valid-client/:token" => "clients/sessions#valid_client", :as => :valid_client
    end
    
    authenticated :client do
      as :client do
        root :to => 'clients/clients#index', :as => :client 
        namespace :clients do            
          match 'import-loc-fin-year' => 'clients#location_financial_year',         :via => [:post],             :as => :loc_fin_year      
          match 'save-loc-fin-year'   => 'clients#save_location_financial_year',    :via => [:post],             :as => :save_loc_fin_year  
          match 'set-loc-fin-year'    => 'clients#set_location_financial_year',     :via => [:post],             :as => :set_loc_fin_year  
          match 'import-master'       => 'imports#import_master',                   :via => [:get, :post],       :as => :import_master           
          
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
          match 'transaction'             => 'imports#transaction',                 :via => [:get, :post],       :as => :import_transaction
          match 'bill-group'              => 'master_entries#bill_group',           :via => [:get, :post]
          match 'item-groups'             => 'master_entries#item_groups',          :via => [:get, :post]
          match 'item-sub-groups'         => 'master_entries#item_sub_groups',      :via => [:get, :post]
          match 'items'                   => 'master_entries#items',                :via => [:get, :post]
          match 'item-groups-kot-print'   => 'master_entries#item_groups_kot',      :via => [:get, :post],       :as => :item_groups_kot
          
          match 'combo-offer'             => 'master_entries#combo_offer',          :via => [:get, :post]
          match 'combo-package'           => 'master_entries#combo_package',        :via => [:get, :post]
          match 'credit-card'             => 'master_entries#credit_card',          :via => [:get, :post]          
          match 'happy-hours'             => 'master_entries#happy_hours',          :via => [:get, :post]         
          
          match 'companies'               => 'master_entries#companies',            :via => [:get]
          match 'location'                => 'master_entries#client_locations',     :via => [:get]
          match 'outlet'                  => 'master_entries#client_outlets',       :via => [:get, :post]
          match 'financial-years'         => 'master_entries#fin_years',            :via => [:get, :post]
          match 'remark-master'           => 'master_entries#remark_master',        :via => [:get, :post]
          match 'customers'               => 'master_entries#customers',            :via => [:get, :post]
          
          match 'tables'                  => 'master_entries#tables',               :via => [:get, :post]
          match 'table-sections'          => 'master_entries#table_sections',       :via => [:get, :post]
          match 'staffs'                  => 'master_entries#staffs',               :via => [:get, :post]          
          match 'waiters'                 => 'master_entries#waiters',              :via => [:get, :post]
          
          
        end
        
       
      end
    end  
  end
  
  match 'check-subdomain'   => 'welcome#check_subdomain',                           :via => :get,                :as => :valid_subdomain
  match 'check-valid-email' => 'welcome#valid_email',                               :via => :get,                :as => :valid_email
  match 'get-locations/:id' => 'welcome#get_locations',     :as => :locations,       :via => :get
  match 'get-outlets/:id'   => 'welcome#get_outlets',       :as => :outlets,         :via => :get
  match 'get-response'      => 'welcome#get_response',      :as => :get_response,    :via => :get
  

  
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
