class Clients::ReportsController < ApplicationController
  before_action :authenticate_client!, :retrieve_data  
  layout "client"
  before_action  :get_outlets#, only: [:frs_report, :product_wise_sale]
  
  def frs_report    
    if request.xhr?
      if params[:outlet_id].present?
        @p_outlets = @outlets.collect { |outlet| outlet if outlet.id == params[:outlet_id].to_i}.compact
        @tax = Tax.where(outlet_id: params[:outlet_id]).first
      else
        @p_outlets = @outlets.order("name asc")
        @tax = Tax.where(location_id: params[:location_id]).first
      end
      @location = @locations.includes(:item_groups).find(params[:location_id])
    end    
  end  
  
  def product_wise_sale
    if request.xhr?
      bill_outlet_query = ''
      if params[:outlet_id].present?
        bill_outlet_query = " and bill_master_backups.outlet_id= #{params[:outlet_id]}"
        @tax = Tax.where(outlet_id: params[:outlet_id]).first
      else
        @tax = Tax.where(location_id: params[:location_id]).first
      end
      @bills = BillDetailBackup.joins(:bill_master_backup).includes(:item => [:item_group, :item_sub_group]).where("bill_master_backups.location_id = ? #{bill_outlet_query} 
        and bill_master_backups.bill_date between ? and ? and bill_detail_backups.canceled = 'NO'", params[:location_id], params[:start_date], params[:end_date])
        .select('bill_master_backup_id, item_id, bill_detail_backups.rate').group(:item_id, :rate)
    end
  end
  
  def sale
    if request.xhr?
      bill_outlet_query = ''
      if params[:outlet_id].present?
        bill_outlet_query = " and bill_master_backups.outlet_id= #{params[:outlet_id]}"
        @tax = Tax.where(outlet_id: params[:outlet_id]).first
      else
        @tax = Tax.where(location_id: params[:location_id]).first
      end
      @bills = BillMasterBackup.where("bill_master_backups.location_id = ? #{bill_outlet_query} and bill_master_backups.bill_date between ? and ?", 
        params[:location_id], params[:start_date], params[:end_date]).select('bill_date, SUM(sub_total_amount) as tot_sub_total_amount, sum(discount) as tot_discount, 
        sum(net_amount) as tot_net_amount, sum(taxable_amount) as tot_taxable_amount, sum(non_taxable_amount) as tot_non_taxable_amount, sum(exciseable_amount) as tot_exciseable_amount,
        sum(s_tax) as tot_s_tax, sum(round_off) as tot_round_off, sum(total_amount) as tot_total_amount, sum(tax1_amount) as tot_tax1_amount, sum(tax2_amount) as tot_tax2_amount, 
        sum(tax3_amount) as tot_tax3_amount, sum(tax4_amount) as tot_tax4_amount, sum(tax5_amount) as tot_tax5_amount, sum(stontax4_amount) as tot_stontax4_amount, sum(service_tax) 
        as tot_service_tax, sum(edu_tax) as tot_edu_tax, sum(hs_edu_tax) as tot_hs_edu_tax').group(:bill_date)      
      
      @tot_bills = BillMasterBackup.where("bill_master_backups.location_id = ? #{bill_outlet_query} and bill_master_backups.bill_date between ? and ?", 
        params[:location_id], params[:start_date], params[:end_date]).select('SUM(sub_total_amount) as tot_sub_total_amount, sum(discount) as tot_discount, sum(net_amount) as 
        tot_net_amount, sum(taxable_amount) as tot_taxable_amount, sum(non_taxable_amount) as tot_non_taxable_amount, sum(exciseable_amount) as tot_exciseable_amount, sum(s_tax) as 
        tot_s_tax, sum(round_off) as tot_round_off, sum(total_amount) as tot_total_amount, sum(tax1_amount) as tot_tax1_amount, sum(tax2_amount) as tot_tax2_amount, sum(tax3_amount) 
        as tot_tax3_amount, sum(tax4_amount) as tot_tax4_amount, sum(tax5_amount) as tot_tax5_amount, sum(stontax4_amount) as tot_stontax4_amount, sum(service_tax) as tot_service_tax, 
        sum(edu_tax) as tot_edu_tax, sum(hs_edu_tax) as tot_hs_edu_tax').first
    end
  end
  
  private
  def get_outlets
    @outlets = current_location.outlets
  end
end
