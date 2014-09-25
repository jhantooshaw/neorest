module Clients::ReportsHelper
  
  def date_format(date)
    date.strftime('%d-%m-%Y')
  end
  
  def time_format(date)
    date.strftime('%I:%M %p')
  end
  
  def change_decimal(value)
    number_with_precision(value, precision: 2)
  end
  
  def get_net_food_global_group(get_under, get_codeNo, table_detail, table_master, outlet_id)
    tot_amt_gross = tot_amt_net = tot_dis = tot_tax = tot_tax_incl = tot_other_tax = 0.0
    temp_gross = temp_net = temp_dis = temp_tax = temp_tax_incl = temp_other_tax = 0.0
    outlet_query = ""
    bill_outlet_query = ""
    
    case table_detail
    when 'bill_detail_backups'
      outlet_query = " and items.outlet_id= #{outlet_id}"
      bill_outlet_query = " and bill_master_backups.outlet_id= #{outlet_id}"        
      @bills = BillDetailBackup.joins(:bill_master_backup, :item => :item_group).where("bill_master_backups.location_id = ? #{bill_outlet_query} 
         and bill_master_backups.bill_date between ? and ? and bill_detail_backups.canceled = 'NO' and item_id in (select id from items where 
         item_group_id = #{get_under} #{outlet_query})", @location.id, params[:start_date], params[:end_date])
      
      @bills.each do |bill|
        temp_gross   = bill.amount
        tot_amt_gross = tot_amt_gross + bill.amount
        if table_detail == "comp_bill_detail_backups"
          temp_dis = 0
        else
          if bill.discountable == 'Yes' && get_dis_applicable(bill.bill_master_backup, bill.excisable, table_master) == true
            temp_dis = get_dis_global(bill.bill_master_backup, bill.amount, table_master)
            tot_dis = tot_dis + temp_dis.to_f
          end
        end
        temp_net = temp_gross - temp_dis.to_f
        tot_amt_net = tot_amt_gross - tot_dis.to_f        
        if table_detail == "comp_bill_detail_backups"
          temp_tax = 0
        else
          if bill.taxable == 'Yes'
            temp_tax = temp_tax + get_tax_global(bill.bill_master_backup, bill.amount, table_master, 'F', bill.mrp*bill.qty, temp_dis).to_f
            tot_tax = tot_tax + temp_tax.to_f
          elsif bill.taxable == 'No' && bill.excisable == 'Yes'
            temp_tax_incl = get_tax_global(bill.bill_master_backup, bill.amount, table_master, 'B', bill.mrp*bill.qty, temp_dis).to_f
            tot_tax_incl = tot_tax_incl + temp_tax_incl.to_f
          end
          temp_other_tax = temp_other_tax + get_tax_st34(bill.bill_master_backup, bill.amount, table_master, 'F', bill.mrp*bill.qty, temp_dis).to_f      
          tot_other_tax = tot_other_tax + temp_other_tax.to_f
        end
      end if @bills.present?
      
      return tot_amt_gross, tot_dis, tot_amt_net, tot_tax , tot_other_tax    
    end    
  end
  
  def get_dis_applicable(master_data, excisable, table_master)
    found = false
    if master_data.dis_both > 0 or (master_data.dis_liquer > 0 && master_data.excisable == 'Yes') or (master_data.dis_food > 0 && master_data.excisable == 'No')
      found = true
    end
    return found
  end
  
  def get_dis_amount(table_master, start_date, end_date, outlet_id)
    tot_dis = 0, tot_net_amt = 0
    case table_master      
    when 'bill_master_backups'
      bill_outlet_query = " and bill_master_backups.outlet_id= #{outlet_id}"
      bills = BillMasterBackup.where("bill_master_backups.location_id = ?#{bill_outlet_query} and bill_master_backups.bill_date between ? and ?", 
        @location.id, params[:start_date], params[:end_date]).select('sum(discount) as tot_discount, sum(net_amount) as tot_net_amount')         
      tot_dis     = number_with_precision(bills[0].tot_discount,   precision: 2) if bills[0].tot_discount.present?
      tot_net_amt = number_with_precision(bills[0].tot_net_amount, precision: 2) if bills[0].tot_net_amount.present?            
    end
    return tot_dis, tot_net_amt
  end
  
  def get_round_off_amount(table_master, start_date, end_date, outlet_id)
    tot_round_off = 0.0
    case table_master      
    when 'bill_master_backups'
      bill_outlet_query = " and bill_master_backups.outlet_id= #{outlet_id}"
      bills = BillMasterBackup.where("bill_master_backups.location_id = ?#{bill_outlet_query} and canceled = 'NO' and bill_master_backups.bill_date between ? and ?", 
        @location.id, params[:start_date], params[:end_date]).select('sum(round_off) as tot_round_off')
      tot_round_off = number_with_precision(bills[0].tot_round_off, precision: 2) if bills[0].tot_round_off.present?            
    end
    return tot_round_off
  end
  
  def get_comp_amount(table_master, start_date, end_date, outlet_id)
    tot_comp = 0.0
    case table_master      
    when 'comp_bill_master_backups'
      bill_outlet_query = " and comp_bill_master_backups.outlet_id= #{outlet_id}"
      bills = CompBillMasterBackup.where("comp_bill_master_backups.location_id = ?#{bill_outlet_query} and comp_bill_master_backups.bill_date between ? and ?",
        @location.id, params[:start_date], params[:end_date]).select('sum(total) as total')
      tot_comp = number_with_precision(bills[0].total, precision: 2) if bills[0].total.present?           
    end    
    return tot_comp
  end
  
  def get_no_bills_voided(table_master, start_date, end_date, outlet_id)
    tot_number = 0
    case table_master  
    when 'bill_master_backups'
      bill_outlet_query = " and bill_master_backups.outlet_id= #{outlet_id}"
      bills = BillMasterBackup.where("bill_master_backups.location_id = ?#{bill_outlet_query} and canceled = 'Yes' and bill_master_backups.bill_date between ? and ?", 
        @location.id, params[:start_date], params[:end_date]).count
      tot_number = bills
    end
    return tot_number
  end
  
  def get_no_bills_edited(table_master, start_date, end_date, outlet_id)
    tot_number = 0
    case table_master  
    when 'bill_master_backups'
      bill_outlet_query = " and bill_master_backups.outlet_id= #{outlet_id}"
      bills = BillMasterBackup.where("bill_master_backups.location_id = ?#{bill_outlet_query} and modified_date is not null and bill_master_backups.bill_date between ? and ?", 
        @location.id, params[:start_date], params[:end_date]).count
      tot_number = bills
    end
    return tot_number
  end
  
  def get_sale(start_date, end_date, outlet_id, pay_type)
    tot_sale = 0
    if pay_type == ""
      bill_outlet_query = " and bill_master_backups.outlet_id= #{outlet_id}"
      bills = BillSettlement.joins(:bill_master_backup).where("bill_master_backups.location_id = ?#{bill_outlet_query} and bill_master_backups.bill_date between ? and ?", 
        @location.id, params[:start_date], params[:end_date]).sum(:pay_amount)
      tot_sale = bills if bills.present?
    else
      bill_outlet_query = " and bill_master_backups.outlet_id= #{outlet_id}"
      bills = BillSettlement.joins(:bill_master_backup).where("bill_master_backups.location_id = ? #{bill_outlet_query} and bill_master_backups.bill_date between ? and ? 
        and bill_settlements.pay_type = ?", @location.id, params[:start_date], params[:end_date], pay_type).sum(:pay_amount)
      tot_sale = bills if bills.present?
    end
    return tot_sale
  end
  
  def get_item_sale(item_id, item_rate)
    temp_qty = 0
    temp_amt = temp_dis = temp_net = temp_tax = temp_other_tax = temp_tax_incl = temp_discount = 0.0
    if params[:outlet_id].present?
      bill_outlet_query = " and bill_master_backups.outlet_id= #{params[:outlet_id]}"        
    end
    
    bills = BillDetailBackup.joins(:bill_master_backup).where("bill_master_backups.location_id = ? #{bill_outlet_query} and bill_master_backups.bill_date between ? and ?
      and bill_detail_backups.canceled = 'NO' and item_id = ? and bill_detail_backups.rate = ?", params[:location_id], params[:start_date], params[:end_date], item_id, item_rate).
      select('bill_master_backup_id, bill_master_backups.bill_no, bill_master_backups.bill_date, bill_master_backups.bill_type, qty, amount, bill_detail_backups.discountable, 
      bill_detail_backups.taxable, bill_detail_backups.excisable, bill_detail_backups.mrp')    
    bills.each do |bill|
      temp_qty = temp_qty + bill.qty
      temp_amt = temp_amt + bill.amount.to_f
      if bill.discountable == 'Yes'
        temp_discount = get_dis_global(bill.bill_master_backup, bill.amount, "bill_master_backups").to_f
      end      
      if bill.taxable == 'Yes'
        temp_tax = temp_tax + get_tax_global(bill.bill_master_backup, bill.amount, "bill_master_backups", 'F', bill.mrp*bill.qty, temp_discount).to_f
      elsif bill.taxable == 'No' && bill.excisable == 'Yes'
        if check_inc_stax(bill.bill_master_backup.outlet.tax) == false
          temp_tax_incl = temp_tax_incl + get_tax_global(bill.bill_master_backup, bill.amount, "bill_master_backups", 'B', bill.mrp*bill.qty, temp_discount).to_f
        end
      end
      temp_other_tax = temp_other_tax + get_tax_st34(bill.bill_master_backup, bill.amount, "bill_master_backups", 'F', bill.mrp*bill.qty, temp_discount).to_f   
      temp_discount = temp_discount
      temp_dis = temp_dis + temp_discount.to_f
      temp_net = temp_net + (bill.amount - temp_discount.to_f)
    end 
    temp_amt        = number_with_precision(temp_amt, precision: 2).to_f 
    temp_discount   = number_with_precision(temp_discount, precision: 2).to_f 
    temp_net        = number_with_precision(temp_net, precision: 2).to_f 
    temp_tax        = number_with_precision(temp_tax, precision: 2).to_f 
    temp_other_tax  = number_with_precision(temp_other_tax, precision: 2).to_f 
    temp_tax_incl   = number_with_precision(temp_tax_incl, precision: 2).to_f     
    return temp_qty, temp_amt, temp_discount, temp_net, temp_tax, temp_other_tax, temp_tax_incl
  end
  
  def get_dis_global(master_data, amount, table_master)
    discount = 0.0
    case table_master  
    when 'bill_master_backups'
      discount = (amount* master_data.dis_per) / 100 if master_data.dis_per > 0
    end    
    return number_with_precision(discount, precision: 2) 
  end
  
  def get_tax_global(master_data, amount, table_master, bar_or_food, mrp, bill_dis)
    tax = 0.0
    case table_master  
    when 'bill_master_backups'
      if bar_or_food == 'F'
        if master_data.tax1_per.present? or master_data.tax1_per != 0
          tax = ((amount-bill_dis.to_f)*master_data.tax1_per)/100
        end
      else
        if master_data.tax2_per.present? or master_data.tax2_per != 0
          tax = ((amount-bill_dis.to_f-mrp.to_f)*master_data.tax2_per)/100
        end
      end
    end    
    return number_with_precision(tax, precision: 2)   
  end
  
  def check_inc_stax(tax)
    found = false
    if tax.rate_incd_of_stax.present? && tax.rate_incd_of_stax == 'Yes'
      found = true
    end
    return found
  end
  
  def get_tax_st34(master_data, amount, table_master, bar_or_food, mrp, bill_dis)
    tax = 0.0
    case table_master  
    when 'bill_master_backups'
      if master_data.tax3_per.present? or master_data.tax3_per != 0
        tax = tax + ((amount-bill_dis.to_f)*master_data.tax3_per)/100
      end
        
      if master_data.tax4_per.present? or master_data.tax4_per != 0
        tax = tax + ((amount-bill_dis.to_f)*master_data.tax4_per)/100
      end
      
      if master_data.service_tax_per.present? or master_data.service_tax_per != 0
        tot_ser_tax_amt = ((amount - bill_dis.to_f)*(100 - get_st_abatement(master_data.outlet.tax)))/100        
        stax_amt  = number_with_precision(tot_ser_tax_amt*master_data.service_tax_per/100, precision: 2)  
        etax_amt  = number_with_precision(tot_ser_tax_amt*master_data.edu_tax_per/100, precision: 2)  
        hstax_amt = number_with_precision(tot_ser_tax_amt*master_data.hs_edu_tax_per/100, precision: 2)         
        tax = tax + stax_amt.to_f + etax_amt.to_f + hstax_amt.to_f
      end      
    end    
    return number_with_precision(tax, precision: 2) 
  end
  
  def get_item_comp_qty(item_id, table_detail)
    qty = 0
    case table_detail      
    when 'comp_bill_detail_backups'
      if params[:outlet_id].present?
        bill_outlet_query = " and comp_bill_master_backups.outlet_id= #{params[:outlet_id]}"
      end
      bills = CompBillDetailBackup.joins(:comp_bill_master_backup).where("comp_bill_master_backups.location_id = ? #{bill_outlet_query} and comp_bill_master_backups.bill_date 
        between ? and ? and comp_bill_detail_backups.canceled = 'NO' and item_id = ?", params[:location_id], params[:start_date], params[:end_date], item_id).sum(:qty)
      qty = bills if bills.present?
    end
    return qty
  end
  
  def get_item_cost_from_menu(item_id, outlet_id)
    cost = 0.0
    outlet = Outlet.find(outlet_id)
    item = outlet.items.find(item_id)
    cost = item.cost if item.present? && item.cost.present?
    return cost
  end
  
  
  def get_tot_taxable_amt(tax_name, tax_field, bill_date, table_master)
    tot_taxable_amt = 0.0 
    case table_master 
    when 'bill_master_backups'
      if params[:outlet_id].present?
        bill_outlet_query = " and outlet_id= #{params[:outlet_id]}"
      end
      bills = BillMasterBackup.where("location_id= ? #{bill_outlet_query} and bill_date between ? and ? and canceled = 'NO' and #{tax_name} > 0", 
        params[:location_id], bill_date, bill_date).sum("#{tax_field}")
      tot_taxable_amt = change_decimal(bills) if bills.present?
    end
    return tot_taxable_amt
  end
  
  def get_tax_amount(tax_field, table_master, outlet_id)
    tot_tax_amt = 0.0 
    case table_master 
    when 'bill_master_backups'
      bill_outlet_query = " and bill_master_backups.outlet_id= #{outlet_id}"      
      bills = BillMasterBackup.where("location_id= ? #{bill_outlet_query} and bill_date between ? and ?", params[:location_id], params[:start_date], 
        params[:end_date]).sum("#{tax_field}")
      tot_tax_amt = change_decimal(bills) if bills.present?
    end
    return tot_tax_amt
  end
  
  def get_all_tax_amount(table_master, outlet_id)
    tot_tax1_amt = tot_tax2_amt = tot_tax3_amt = tot_tax4_amt = tot_tax5_amt = tot_service_tax = tot_edu_tax = tot_hs_edu_tax = 0.0 
    case table_master 
    when 'bill_master_backups'
      bill_outlet_query = " and bill_master_backups.outlet_id= #{outlet_id}"      
      bills = BillMasterBackup.where("location_id= ? #{bill_outlet_query} and bill_date between ? and ?", params[:location_id], params[:start_date], params[:end_date]).
        select('sum(tax1_amount) as tot_tax1_amount, sum(tax2_amount) as tot_tax2_amount, sum(tax3_amount) as tot_tax3_amount, sum(tax4_amount) as tot_tax4_amount, 
        sum(tax5_amount) as tot_tax5_amount, sum(service_tax) as tot_service_tax, sum(edu_tax) as tot_edu_tax, sum(hs_edu_tax) as tot_hs_edu_tax')      
      tot_tax1_amt    = change_decimal(bills[0].tot_tax1_amount) if bills[0].tot_tax1_amount.present?
      tot_tax2_amt    = change_decimal(bills[0].tot_tax2_amount) if bills[0].tot_tax2_amount.present? 
      tot_tax3_amt    = change_decimal(bills[0].tot_tax3_amount) if bills[0].tot_tax3_amount.present? 
      tot_tax4_amt    = change_decimal(bills[0].tot_tax4_amount) if bills[0].tot_tax4_amount.present? 
      tot_tax5_amt    = change_decimal(bills[0].tot_tax5_amount) if bills[0].tot_tax5_amount.present? 
      tot_service_tax = change_decimal(bills[0].tot_service_tax) if bills[0].tot_service_tax.present? 
      tot_edu_tax     = change_decimal(bills[0].tot_edu_tax)     if bills[0].tot_edu_tax.present? 
      tot_hs_edu_tax  = change_decimal(bills[0].tot_hs_edu_tax)  if bills[0].tot_hs_edu_tax.present? 
    end
    return tot_tax1_amt, tot_tax2_amt, tot_tax3_amt, tot_tax4_amt, tot_tax5_amt, tot_service_tax, tot_edu_tax, tot_hs_edu_tax
  end
  
  
  def get_st_abatement(tax) 
    abatement = 0.0
    if tax.abatement > 0
      abatement = tax.abatement
    end
    return abatement
  end
  
  def get_ser_taxable_amt(bill_date, table_master)
    tot_ser_taxable_amt = 0.0 
    case table_master 
    when 'bill_master_backups'
      if params[:outlet_id].present?
        bill_outlet_query = " and outlet_id= #{params[:outlet_id]}"
      end   
      bills = BillMasterBackup.where("location_id= ? #{bill_outlet_query} and bill_date=? and tax4_amount > 0", 
        params[:location_id], bill_date).sum(:net_amount)
      tot_ser_taxable_amt = change_decimal(bills) if bills.present?
    end
    return tot_ser_taxable_amt
  end
end