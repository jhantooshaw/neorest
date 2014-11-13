class Clients::ReportsController < ApplicationController
  before_action :authenticate_client!, :retrieve_data  
  layout "client"
  before_action  :get_outlets#, only: [:frs_report, :product_wise_sale]
  
  def frs_report    
    if request.xhr?
      bill_outlet_query = ''
      if params[:outlet_id].present?
        @p_outlets = @outlets.collect { |outlet| outlet if outlet.id == params[:outlet_id].to_i}.compact
        bill_outlet_query = " and bill_master_backups.outlet_id= #{params[:outlet_id]}"
        @tax = Tax.where(outlet_id: params[:outlet_id]).first
      else
        @p_outlets = @outlets.order("name asc")
        #@tax = Tax.where(location_id: params[:location_id]).first
        @taxes = Tax.where(location_id: params[:location_id])
        if @taxes.count > 1
          
        end
        
        
      end
      @location = @locations.includes(:item_groups).find(params[:location_id])
      
      @bills = BillDetailBackup.joins(:bill_master_backup).where("bill_master_backups.location_id = ? #{bill_outlet_query} 
        and bill_master_backups.bill_date between ? and ? and bill_detail_backups.canceled = 'NO'", params[:location_id], params[:start_date], params[:end_date]).count
      
      
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
      .group(:item_id, :rate).paginate(:page => params[:page])
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
      
      @tot_ser_bills = BillMasterBackup.where("bill_master_backups.location_id = ? #{bill_outlet_query} and bill_master_backups.bill_date between ? and ? and tax4_amount > 0", 
        params[:location_id], params[:start_date], params[:end_date]).select('sum(net_amount) as 
        tot_ser_taxable_amount').first      
    end
  end
  
  def login
    if request.xhr?
      bill_outlet_query = ''
      if params[:outlet_id].present?
        bill_outlet_query = "and bill_master_backups.outlet_id=#{params[:outlet_id]}"     
      end
      
      @bills_count = BillMasterBackup.where("bill_master_backups.location_id=? #{bill_outlet_query} and bill_master_backups.bill_date between ? and ?", 
        params[:location_id].to_i, params[:start_date], params[:end_date]).count  
      
      if @bills_count > 0
        @bills = BillMasterBackup.where("bill_master_backups.location_id=? #{bill_outlet_query} and bill_master_backups.bill_date between ? and ? and modified_name != ''", 
          params[:location_id].to_i, params[:start_date], params[:end_date]).select('id, bill_date, bill_no, bill_time, actual_amount, staff_name, total_amount, modified_time, 
          settle_time, modified_name').paginate(:page => params[:page])
      end
      
    end
  end
  
  def void_bills
    if request.xhr?
      if params[:outlet_id].present?
        bill_outlet_query = "and outlet_id=#{params[:outlet_id]}"     
      end
      void_bills = VoidBill.where("location_id=? #{bill_outlet_query} and bill_date between ? and ?",params[:location_id].to_i, params[:start_date], params[:end_date])
      @bills = void_bills.group_by(&:bill_date) 
    end
  end
  
 
  
end
