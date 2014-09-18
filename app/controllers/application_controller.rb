class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, :if => :devise_controller?
  before_action :valid_subdomain_required?
    
    

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:hotel_name, :phone, :mobile, :address, :city, :zipcode, :subdomain, :state_id, :country_id, :roles_mask, roles: []]
  end
    
  def valid_subdomain_required?    
    subdomain = request.subdomain($tld_length)  
    case subdomain
    when 'admin', 'www','', nil
      true
    else
      render(:template => "layouts/subdomain_missing", :layout => false) if Client.where(:subdomain => subdomain).first.blank?
    end
  end
  
  def retrieve_data
    @locations = current_client.locations
    @f_years   = current_client.financial_years    
    @fin_locs  = current_client.financial_years_locations 
  end
  
  def current_year
    @current_year ||= (session[:financial_year_id].present? && current_client.financial_years.find(session[:financial_year_id])) #unless current_client.financial_years.blank?
  end
  
  def current_location
    @current_location ||= (session[:location_id].present? && current_client.locations.find(session[:location_id])) #unless current_client.locations.blank?
  end
  
  
  helper_method :current_year, :current_location
  
  def clear_message    
    current_scope = current_resource_scope
    case current_scope
    when "client"
      sign_out(current_scope)
    end
    # flash[:alert] = nil
    # flash[:info] = nil
  end
  
  def current_resource_scope
    if current_client
      "client"    
    end
  end
  
  def signed_in?(scope=nil)
    found = false
    [ scope || Devise.mappings.keys ].flatten.any? do |_scope|
      found = warden.authenticate?(:scope => _scope)
      if found== true
        break
      end
    end
    if found == false
      flash[:notice] = "You need to sign in before continuing."
      redirect_to root_path
    end
  end
  
  
    
end