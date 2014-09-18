module Devise
  module Controllers
    module Helpers

      def after_sign_in_path_for_subdomain_for_admin(resource_or_scope)
        subdomain_name = "admin" #current_hotelier.hotel.subdomain
        if current_subdomain.blank?
          # logout of root domain and login by token to subdomain
          sign_out(current_siteadmin)         
          home_path =  siteadmins_dashboard_index_url(:subdomain => subdomain_name)
          return home_path
        else
          unless subdomain_name == current_subdomain
            # user not part of current_subdomain
            sign_out(current_siteadmin)
            flash[:notice] = nil
            #set_flash_message(:error, :subdomain)
            set_flash_message(:error, "Sub domain does not match")

            after_sign_out_path_for(resource_or_scope)
          else
            stored_location_for(resource_or_scope) || siteadmins_dashboard_index_url
          end
        end
      end


      def after_sign_in_path_for_subdomain_for_client(resource_or_scope)
        subdomain_name = current_client.subdomain
        if request.subdomain($tld_length).blank?
          # logout of root domain and login by token to subdomain
          token =  current_client.authentication_token
          current_client.authentication_token = token
          current_client.save   
          sign_out(resource_or_scope)
          home_path = valid_client_url(token, :subdomain => subdomain_name)
          return home_path
        else
          if subdomain_name != request.subdomain($tld_length)
            # user not part of current_subdomain
            sign_out(current_client)
            flash[:notice] = nil
            #set_flash_message(:error, :subdomain)
            set_flash_message(:error, "Sub domain does not match")
            after_sign_out_path_for(resource_or_scope)
          else           
            stored_location_for(resource_or_scope) || signed_in_root_path(resource_or_scope)
          end
        end
      end

      def after_sign_in_path_for(resource)
        if resource.is_a? Client
          stored_location_for(resource) || client_root_path
        elsif resource.is_a? Consumer
          puts"============current resource #{resource.to_yaml}"
          stored_location_for(resource) || authenticated_consumer_path
        elsif resource.is_a? RiskManagement
          puts"============current resource #{resource.to_yaml}"
          stored_location_for(resource) || authenticated_risk_management_path
       
        else

        end
      end
      
      def after_sign_out_path_for(resource_or_scope)
       # if resource.is_a? Client
          new_client_session_url
      #  end
      end

    end
  end
end