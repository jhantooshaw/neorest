class WelcomeController < ApplicationController
  #before_action :authenticate_client!
  
  before_action  :retrieve_data, only: [:get_locations] 
  
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
  
  # check valid email
  def valid_email
    name = params[:fieldValue]
    if name.strip == ""
      render :json => { :available => false }
      return
    end
    user = Client.where(:email => name.downcase).first
    if user.blank?
      render :json =>  ["client_email", false , ""]
    else
      render :json =>  ["client_email", true , ""]
    end
  end 
  
  # get all location for particular financial year
  def get_locations
    @f_year = FinancialYear.find(params[:id])
    @f_locations = @f_year.locations.select("id,name")
    if params[:multiple_type] == true || params[:multiple_type] == 'true'
      @fin_locs = @f_year.financial_years_locations
      render partial: "shared/location_select_multiple"
    else
      render partial: "shared/location_select"
    end    
  end
  
  # get all outlets for particular location
  def get_outlets
    location = current_client.locations.select("id").find(params[:id])
    @outlets = location.outlets
    render partial: "shared/outlets_select"
  end
  
  def get_response   
    render :json => { :txt => 'OK' }
  end
end
