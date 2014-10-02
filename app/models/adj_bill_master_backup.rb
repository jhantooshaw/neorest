class AdjBillMasterBackup < ActiveRecord::Base
  belongs_to :location
  belongs_to :financial_year
  belongs_to :outlet
  belongs_to :waiter
  belongs_to :steward
  belongs_to :tax
  belongs_to :customer
  
  has_many   :adj_bill_detail_backups,          dependent: :destroy
  has_many   :adj_bill_settlements,             dependent: :destroy
  
  validates  :bill_no, :bill_date, :bill_type, :location, :outlet, :financial_year, presence:  true
  validates_uniqueness_of :bill_no, scope: [:bill_date, :bill_type, :location, :outlet, :financial_year], case_sensitive: false, message: "duplicate entry" 
  
  default_scope {where(step: 'imported')}
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Adj Bill Master Backup Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        outlet_name = sheet.cell(line, 'E')
        outlet      = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found into database" if outlet.blank?
        fin_year_name = sheet.cell(line, 'G')
        fin_year      = location.financial_years.where(name: fin_year_name).first
        raise "Financial Year #{fin_year_name} is not found into database" if fin_year.blank?
        waiter       = location.waiters.where(w_no: sheet.cell(line, 'I').to_i).first if sheet.cell(line, 'I').present? && sheet.cell(line, 'I').to_i != 0
        steward      = location.waiters.where(s_no: sheet.cell(line, 'K').to_i).first if sheet.cell(line, 'K').present? && sheet.cell(line, 'K').to_i != 0
        staff        = location.staffs.where(name: sheet.cell(line, 'AQ')).first unless sheet.cell(line, 'AQ').blank?       
        staff_mod    = location.staffs.where(name: sheet.cell(line, 'AR')).first unless sheet.cell(line, 'AR').blank?       
        customer     = location.customers.where(c_name: sheet.cell(line, 'AX')).first unless sheet.cell(line, 'AX').blank?      
        
        bill_no      = sheet.cell(line, 'A').to_i
        bill_date    = sheet.cell(line, 'C')
        bill_type    = sheet.cell(line, 'D')
        #p "Settle Time: #{sheet.cell(line, 'BM')}"
        
        params = { 
          table_no:        sheet.cell(line, 'B'),
          bill_time:       sheet.cell(line, 'H'),
          dis_per:         sheet.cell(line, 'M').to_f,
          discount:        sheet.cell(line, 'N').to_f,
          service_tax_per: sheet.cell(line, 'O').to_i,
          service_tax:     sheet.cell(line, 'P').to_f,
          edu_tax_per:     sheet.cell(line, 'Q').to_f,
          edu_tax:         sheet.cell(line, 'R').to_f,
          hs_edu_tax_per:  sheet.cell(line, 'S').to_f,
          hs_edu_tax:      sheet.cell(line, 'T').to_f,
          tax1:            sheet.cell(line, 'U'),
          tax1_per:        sheet.cell(line, 'V').to_f,
          tax1_amount:     sheet.cell(line, 'W').to_f,
          tax2:            sheet.cell(line, 'X'),
          tax2_per:        sheet.cell(line, 'Y').to_f,
          tax2_amount:     sheet.cell(line, 'Z').to_f,
          tax3:            sheet.cell(line, 'AA'),
          tax3_per:        sheet.cell(line, 'AB').to_f,
          tax3_amount:     sheet.cell(line, 'AC').to_f,
          tax4:            sheet.cell(line, 'AD'),
          tax4_per:        sheet.cell(line, 'AE').to_f,
          tax4_amount:     sheet.cell(line, 'AF').to_f,
          s_tax:           sheet.cell(line, 'AG').to_f,
          excise_amount:   sheet.cell(line, 'AH').to_f,
          round_off:       sheet.cell(line, 'AI').to_f,
          net_amount:      sheet.cell(line, 'AJ').to_f,
          total_amount:    sheet.cell(line, 'AK').to_f,
          sub_total_amount:   sheet.cell(line, 'AL').to_f,
          taxable_amount:     sheet.cell(line, 'AM').to_f,
          non_taxable_amount: sheet.cell(line, 'AN').to_f,
          exciseable_amount:  sheet.cell(line, 'AO').to_f,
          pay_type:        sheet.cell(line, 'AP'),
          staff_id:        staff.present?  ? staff.id  : nil, 
          staff_name:      sheet.cell(line, 'AQ'),         
          modified_by:     staff_mod.present?  ? staff_mod.id  : nil,
          modified_name:   sheet.cell(line, 'AR'),
          modified_date:   sheet.cell(line, 'AS').present? ? Date.strptime(sheet.cell(line, 'AS'), '%m/%d/%Y') : nil,
          modified_time:   sheet.cell(line, 'AT'),
          canceled:        sheet.cell(line, 'AU'),
          cover:           sheet.cell(line, 'AV').to_i,
          comment:         sheet.cell(line, 'AW'),
          customer_id:     customer.present?   ? customer.id : nil, 
          customer_name:   sheet.cell(line, 'AX'),       
          delivery:        sheet.cell(line, 'AY'),
          cc_name:         sheet.cell(line, 'AZ'),
          actual_amount:   sheet.cell(line, 'BA').to_f,
          food_amount:     sheet.cell(line, 'BB').to_f,
          food_tax:        sheet.cell(line, 'BC').to_f,
          food_total:      sheet.cell(line, 'BD').to_f,
          beverage_amount: sheet.cell(line, 'BE').to_f,
          beverage_tax:    sheet.cell(line, 'BF').to_f,
          beverage_total:  sheet.cell(line, 'BG').to_f,
          wine_amount:     sheet.cell(line, 'BH').to_f,
          beer_amount:     sheet.cell(line, 'BI').to_f,
          cal_sub_total:   sheet.cell(line, 'BJ').to_f,
          tips:            sheet.cell(line, 'BK').to_f,
          grand_total:     sheet.cell(line, 'BL').to_f,
          settle_time:     sheet.cell(line, 'BM'),
          no_of_print:     sheet.cell(line, 'BN').to_i,
          pay_changed:     sheet.cell(line, 'BO'),
          dis_food:        sheet.cell(line, 'BP').to_f,
          dis_liquer:      sheet.cell(line, 'BQ').to_f,
          dis_both:        sheet.cell(line, 'BR').to_f,
          room_no:         sheet.cell(line, 'BS'),
          hotel_date:      sheet.cell(line, 'BT'),
          banquet:         sheet.cell(line, 'BU'),
          out_time:        sheet.cell(line, 'BV'),          
          rate_incd_of_tax1: sheet.cell(line, 'BW') == 'false' ? false : true, 
          tax_cal_after_dis: sheet.cell(line, 'BX'),
          rate_incd_of_stax: sheet.cell(line, 'BY') == 'false' ? false : true, 
          service_tax_applicable: sheet.cell(line, 'BZ') == 'false' ? false : true, 
          abatement:       sheet.cell(line, 'CA').to_f,
          tax1_cal_last:   sheet.cell(line, 'CB') == 'false' ? false : true, 
          linked_financial_year:  sheet.cell(line, 'CC'),          
          tax5:            sheet.cell(line, 'CD'),
          tax5_per:        sheet.cell(line, 'CE').to_f,
          tax5_amount:     sheet.cell(line, 'CF').to_f,          
          stontax4:        sheet.cell(line, 'CG') == 'false' ? false : true,
          stontax4_per:    sheet.cell(line, 'CH').to_f,
          stontax4_amount: sheet.cell(line, 'CI').to_f,
          waiter_id:       waiter.present?  ? waiter.id  : nil,        
          steward_id:      steward.present? ? steward.id : nil        
        }
        
        adj_bill_master_backup = AdjBillMasterBackup.unscoped.where(location_id: location.id, outlet_id: outlet.id, financial_year_id: fin_year.id, bill_no: bill_no,
          bill_date: bill_date, bill_type: bill_type).first_or_initialize                
        adj_bill_master_backup.update_attributes!(params)  if adj_bill_master_backup.new_record?       
      end
    rescue Exception => e
      success = false
      msg = e.message + " in adj bill master backup at line no #{$line}"
    end      
    return success, msg
  end
  
  def self.change_step(from, to)
    unscoped.where(step: from).update_all(step: to)
  end
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    begin
      raise "Please set proper header for adj_bill_master_backup sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Bill_No" ||
          sheet.cell(1, 'B').to_s.strip != "Table_No" || sheet.cell(1, 'C').to_s.strip != "Bill_Date" || sheet.cell(1, 'D').to_s.strip != "Bill_Type"   || 
          sheet.cell(1, 'E').to_s.strip != "Outlet"   || sheet.cell(1, 'F').to_s.strip != "LocationName" || sheet.cell(1, 'G').to_s.strip != "Financial_Year_Name"   || 
          sheet.cell(1, 'H').to_s.strip != "Bill_Time"|| sheet.cell(1, 'I').to_s.strip != "Wtr_No" || sheet.cell(1, 'J').to_s.strip != "Wtr_Name"  || 
          sheet.cell(1, 'K').to_s.strip != "Stew_No"  || sheet.cell(1, 'L').to_s.strip != "Stew_Name" || sheet.cell(1, 'M').to_s.strip != "Dis%" || 
          sheet.cell(1, 'N').to_s.strip != "Dis"      || sheet.cell(1, 'O').to_s.strip != "ServiceTaxPer" || sheet.cell(1, 'P').to_s.strip != "ServiceTax" || 
          sheet.cell(1, 'Q').to_s.strip != "EducationCessPer"|| sheet.cell(1, 'R').to_s.strip != "EducationCess" || sheet.cell(1, 'S').to_s.strip != "SecondaryHigherEducationCessPer" || 
          sheet.cell(1, 'T').to_s.strip != "SecondaryHigherEducationCess" ||  sheet.cell(1, 'U').to_s.strip != "Tax1" || sheet.cell(1, 'V').to_s.strip != "Tax1Per" || 
          sheet.cell(1, 'W').to_s.strip != "Tax1Amt"  || sheet.cell(1, 'X').to_s.strip != "Tax2" || sheet.cell(1, 'Y').to_s.strip != "Tax2Per" || sheet.cell(1, 'Z').to_s.strip != "Tax2Amt" || 
          sheet.cell(1, 'AA').to_s.strip != "Tax3"    || sheet.cell(1, 'AB').to_s.strip != "Tax3Per"|| sheet.cell(1, 'AC').to_s.strip != "Tax3Amt" || sheet.cell(1, 'AD').to_s.strip != "Tax4"  ||  
          sheet.cell(1, 'AE').to_s.strip != "Tax4Per" || sheet.cell(1, 'AF').to_s.strip != "Tax4Amt"|| sheet.cell(1, 'AG').to_s.strip != "S_Tax"   || sheet.cell(1, 'AH').to_s.strip != "Excise_Amt"   || 
          sheet.cell(1, 'AI').to_s.strip != "Round_Off" || sheet.cell(1, 'AJ').to_s.strip != "Net_Amt"  || sheet.cell(1, 'AK').to_s.strip != "Total" || sheet.cell(1, 'AL').to_s.strip != "Sub_Total"   || 
          sheet.cell(1, 'AM').to_s.strip != "Taxable_Amt" || sheet.cell(1, 'AN').to_s.strip != "Non_Taxable_Amt" || sheet.cell(1, 'AO').to_s.strip != "Exciseable_Amt" || sheet.cell(1, 'AP').to_s.strip != "Pay_Type"   || 
          sheet.cell(1, 'AQ').to_s.strip != "User" || sheet.cell(1, 'AR').to_s.strip != "Mod_User" || sheet.cell(1, 'AS').to_s.strip != "Mod_Date" || sheet.cell(1, 'AT').to_s.strip != "Mod_Time"   || 
          sheet.cell(1, 'AU').to_s.strip != "Canceled" || sheet.cell(1, 'AV').to_s.strip != "Covers"   || 
          sheet.cell(1, 'AW').to_s.strip != "Comment" || sheet.cell(1, 'AX').to_s.strip != "Customer"   || 
          sheet.cell(1, 'AY').to_s.strip != "Delivery" || sheet.cell(1, 'AZ').to_s.strip != "CC_Name"   ||              
          sheet.cell(1, 'BA').to_s.strip != "Actual_Amt" || sheet.cell(1, 'BB').to_s.strip != "Food_Amt"   || 
          sheet.cell(1, 'BC').to_s.strip != "Food_Tax" || sheet.cell(1, 'BD').to_s.strip != "Food_Total"   || 
          sheet.cell(1, 'BE').to_s.strip != "Beverage_Amt" || sheet.cell(1, 'BF').to_s.strip != "Beverage_Tax"   || 
          sheet.cell(1, 'BG').to_s.strip != "Beverage_Total" || sheet.cell(1, 'BH').to_s.strip != "Wine_Amt"   || 
          sheet.cell(1, 'BI').to_s.strip != "Beer_Amt" || sheet.cell(1, 'BJ').to_s.strip != "Cal_Sub_Total"   || 
          sheet.cell(1, 'BK').to_s.strip != "Tips" || sheet.cell(1, 'BL').to_s.strip != "Grand_Total"   || 
          sheet.cell(1, 'BM').to_s.strip != "Settle_Time" || sheet.cell(1, 'BN').to_s.strip != "NoOfPrint"   || 
          sheet.cell(1, 'BO').to_s.strip != "PayChanged" || sheet.cell(1, 'BP').to_s.strip != "DisFood"   || 
          sheet.cell(1, 'BQ').to_s.strip != "DisLiquer" || sheet.cell(1, 'BR').to_s.strip != "DisBoth"   || 
          sheet.cell(1, 'BS').to_s.strip != "Room_No" || sheet.cell(1, 'BT').to_s.strip != "Hotel_Date"   || 
          sheet.cell(1, 'BU').to_s.strip != "Banquet" || sheet.cell(1, 'BV').to_s.strip != "Out_Time"   || 
          sheet.cell(1, 'BW').to_s.strip != "RateIncOfTax1" || sheet.cell(1, 'BX').to_s.strip != "TacCalAfterDis"   || 
          sheet.cell(1, 'BY').to_s.strip != "RateIncOfSTax" || sheet.cell(1, 'BZ').to_s.strip != "ServiceTaxApplicable"  ||           
          sheet.cell(1, 'CA').to_s.strip != "Abatement" || sheet.cell(1, 'CB').to_s.strip != "Tax1CalLast"   || 
          sheet.cell(1, 'CC').to_s.strip != "LinkedFinancialYear" || sheet.cell(1, 'CD').to_s.strip != "Tax5"   || 
          sheet.cell(1, 'CE').to_s.strip != "Tax5Per" || sheet.cell(1, 'CF').to_s.strip != "Tax5Amt"   || 
          sheet.cell(1, 'CG').to_s.strip != "StOnTax4Applicable" || sheet.cell(1, 'CH').to_s.strip != "StOnTax4Per"   || 
          sheet.cell(1, 'CI').to_s.strip != "StOnTax4Amt"             
      )    
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end
  
end