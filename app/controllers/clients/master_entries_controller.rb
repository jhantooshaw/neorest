class Clients::MasterEntriesController < ApplicationController
  before_action :authenticate_client!, :retrieve_data, :get_outlets 
  before_action :get_outlet_query, except: [:bill_group, :credit_card, :customers, :item_groups, :item_sub_groups, :item_groups_kot]
  layout "client"
  
  # list of all bill group
  def bill_group
    @entries = BillGroup.where(location_id: params[:location]).paginate(:page => params[:page]) if request.xhr?    
  end
  
  # list of all combo offer
  def combo_offer
    @entries = ComboOffer.includes(:combo_package, :outlet).where("location_id=? #{@outlet_query}", params[:location_id].to_i).paginate(:page => params[:page]) if request.xhr?    
  end
  
  # list of all combo package
  def combo_package
    @entries = ComboPackage.where(location_id: params[:location]).paginate(:page => params[:page]) if request.xhr?    
  end
  
  # list of all credit card available
  def credit_card
    @entries = CreditCard.where(location_id: params[:location]).paginate(:page => params[:page]) if request.xhr?    
  end
  
  # list of all customers
  def customers
    @entries = Customer.where(location_id: params[:location]).paginate(:page => params[:page]) if request.xhr?    
  end
  
  # list of all happy hours
  def happy_hours
    @entries = HappyHour.includes(:combo_package, :outlet).where("location_id=? #{@outlet_query}", params[:location_id].to_i).paginate(:page => params[:page]) if request.xhr?    
  end
  
  # list of all item groups
  def item_groups
    @entries = ItemGroup.where(location_id: params[:location]).paginate(:page => params[:page]) if request.xhr?   
  end  
  
  # list of all item sub groups
  def item_sub_groups
    @entries = ItemSubGroup.where(location_id: params[:location]).paginate(:page => params[:page]) if request.xhr?   
  end
  
  # list of all item groups kot print
  def item_groups_kot
    @entries = ItemGroupsKotPrint.where(location_id: params[:location]).paginate(:page => params[:page]) if request.xhr?   
  end
  
  # list of all items
  def items
    @entries = Item.includes(:outlet, :item_group, :item_sub_group, :item_groups_kot_print, :bill_group).where("location_id=? #{@outlet_query}", params[:location_id].to_i).paginate(:page => params[:page]) if request.xhr?   
  end
  
  # list of all locations
  def client_locations
    @entries = @locations
  end
  
  # list of all outlets
  def client_outlets
    @entries = Outlet.where(location_id: params[:location]) if request.xhr?  
  end
  
  # list of all remarks
  def remark_master
    @entries = RemarkMaster.where(location_id: params[:location]) if request.xhr?   
  end
  
  # list of all tables master
  def tables
    @entries = Table.includes(:outlet, :table_section).where("location_id=? #{@outlet_query}", params[:location_id].to_i).paginate(:page => params[:page]) if request.xhr?   
  end
  
  # list of all tables section
  def table_sections
    @entries = TableSection.includes(:outlet).where("location_id=? #{@outlet_query}", params[:location_id].to_i).paginate(:page => params[:page]) if request.xhr?   
  end
  
  # list of all staffs
  def staffs
    @entries = Staff.includes(:outlet).where("location_id=? #{@outlet_query}", params[:location_id].to_i).paginate(:page => params[:page]) if request.xhr?   
  end
  
  # list of all waiters
  def waiters
    @entries = Waiter.includes(:outlet).where("location_id=? #{@outlet_query}", params[:location_id].to_i).paginate(:page => params[:page]) if request.xhr?   
  end
  
  # list of all financial Year
  def fin_years
    @entries = FinancialYear.joins(:financial_years_locations).where("financial_years_locations.location_id=?", params[:location]).order("start_date desc") if request.xhr?   
  end
  
end