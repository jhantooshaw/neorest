class Clients::ClientsController < ApplicationController  
  before_action :authenticate_client!, :retrieve_data  
  layout "client"
  
  def index    
  end
  
  
  # Import location and financial years first from excel file
  def location_financial_year
    @error = ""  
    status = ""
    begin
      unless params[:location].blank?
        set_original_path(params[:location]) 
        data = Roo::Spreadsheet.open(@original_path)        
        data.default_sheet = "Location"
        status = Location.import(data, current_client) unless data.last_row <= 1
        raise status[1] if status [0] == false 
        begin
          data.default_sheet = "strTable" 
          status = Company.import(data, current_client) unless data.last_row <= 1          
        rescue Exception => e          
        end
        raise status[1] if status [0] == false 
      end 
      
      unless params[:financial_year].blank? 
        set_original_path(params[:financial_year]) 
        data = Roo::Spreadsheet.open(@original_path)   
        
        data.default_sheet = "Financial_Year"
        status = FinancialYear.import(data, current_client) unless data.last_row <= 1
        raise status[1] if status [0] == false
      end
    end
    flash[:notice] = "Data is imported successfully."
    redirect_to client_path
  rescue Exception => e
    @error = e.message
    render :index
  end
  
  def save_location_financial_year
    if params[:location_ids].present? && params[:financial_year_ids].present?
      begin
        ActiveRecord::Base.transaction do
          params[:location_ids].each do |loc_id|
            loc_fin_year = current_client.financial_years_locations.where(financial_year_id: params[:financial_year_ids], location_id: loc_id).first
            current_client.financial_years_locations.build(financial_year_id: params[:financial_year_ids], location_id: loc_id) unless loc_fin_year.present?
          end
          current_client.update_attributes(updated_at: Time.now)
          flash[:notice] = "Financial Years are set successfully with locations."
        end
      rescue Exception => e
        @error = e.message
        render :index
        return
      end
    end
    redirect_to client_path
  end
  
  # set current financial year with location
  def set_location_financial_year
    @current_year     = current_client.financial_years.find(params[:financial_year_id])
    @current_location = current_client.locations.find(params[:location_id])
    session[:financial_year_id] = params[:financial_year_id]
    session[:location_id] = params[:location_id]
    flash[:notice] = "Financial Year and Location are set successfully."
    redirect_to client_path
  end  
  
  private
  def set_original_path(params_file)
    file_name = params_file.original_filename
    dest = File.join(Rails.root, "tmp")
    FileUtils.mkdir_p(dest) unless File.exists?(dest)
    @original_path = File.join(dest, file_name).to_s
    File.delete(@original_path) if File.exist?(@original_path)
    File.open(@original_path, "wb") { |f| f.write(params_file.tempfile.read) }
  end
end