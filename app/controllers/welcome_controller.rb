class WelcomeController < ApplicationController
  #before_action :authenticate_client!
  
  
  def index
    redirect_to new_client_session_path
  end
  
  # check subdomain availability
  def check_subdomain
    name = params[:fieldValue]
    if name.strip == ""
      render :json => { :available => false }
      return
    end
    user = Client.where(:subdomain => name.downcase).first
    if user
      render :json =>  ["client_subdomain", false , "This subdomain is already taken"]
    else
      render :json =>  ["client_subdomain", true , ""]
    end
  end 
  
  # get all location for particular financial year
  def get_locations
    @f_year = FinancialYear.find(params[:id])
    @locations = @f_year.locations.select("id,name")
    render partial: "shared/location_select"
  end
  
  # get all outlets for particular location
  def get_outlets
    location = current_client.locations.select("id").find(params[:id])
    @outlets = location.outlets
    render partial: "shared/outlets_select"
  end
end
