class Clients::SessionsController < Devise::SessionsController
  
  #before_action :clear_message,   :only   => [:destroy]
  
  def create   
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    #respond_with resource, :location => after_sign_in_path_for(resource)
    redirect_to after_sign_in_path_for_subdomain_for_client(resource)
  end
  
  # DELETE /resource/sign_out
  def destroy
    super()
#    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
#    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
#    Rails.logger.info "============= Regex match : #{request.referer.gsub("#{request.subdomain(0)}.", "").match(/\A([a-z:\/\/]+[a-z0-9.:]+\/{1,})/i)[0]}"
#    #sign_out_url = request.referer.gsub("#{request.subdomain(0)}.", "").match(/\A([a-z:\/\/]+[a-z0-9.:]+\/{1,})/i)[0]
#    # We actually need to hardcode this as Rails default responder doesn't
#    # support returning empty response on GET request
#    session[:financial_year_id] = session[:location_id] = nil
#    respond_to do |format|
#      format.all { head :no_content }
#      format.any(*navigational_formats) { redirect_to after_sign_out_path_for }
#    end
  end
  
  def valid_client
    self.resource = resource_class.find_for_token_authentication(:auth_token => params[:token].to_s)
    unless resource.blank?
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource, :bypass => true)
      redirect_to stored_location_for(resource) || client_path
    else
      set_flash_message(:error, :subdomain)
      redirect_to :back
    end
  end
end