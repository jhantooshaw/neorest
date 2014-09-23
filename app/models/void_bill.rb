class VoidBill < ActiveRecord::Base
  belongs_to :location
  belongs_to :financial_year
  belongs_to :outlet
  belongs_to :waiter
  belongs_to :customer
  
  validates  :bill_no, :bill_date, :bill_type, :location, :outlet, :financial_year, :table_no, presence:  true
  validates_uniqueness_of :bill_no, scope: [:bill_date, :bill_type, :location, :outlet, :financial_year], case_sensitive: false, message: "duplicate entry" 
  
  default_scope {where(step: 'imported')}
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Void Bill Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        outlet_name = sheet.cell(line, 'E')
        outlet      = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found into database" if outlet.blank?
        fin_year_name = sheet.cell(line, 'G')
        fin_year      = location.financial_years.where(name: fin_year_name).first
        raise "Financial Year #{fin_year_name} is not found into database" if fin_year.blank? 
        table_no     = sheet.cell(line, 'B')
        raise "Table no should not be blank" if table_no.blank? 
        waiter_id    = sheet.cell(line, 'I').to_i unless sheet.cell(line, 'I').blank?
        customer     = location.customers.where(c_name: sheet.cell(line, 'V')).first unless sheet.cell(line, 'V').blank?        
        bill_no      = sheet.cell(line, 'A').to_i
        bill_date    = sheet.cell(line, 'C')
        bill_type    = sheet.cell(line, 'D')       
        params = { 
          table_no:        table_no,
          bill_time:       sheet.cell(line, 'H'),
          dis_per:         sheet.cell(line, 'K').to_f,
          discount:        sheet.cell(line, 'L').to_f,
          s_tax:           sheet.cell(line, 'M').to_f,
          total:           sheet.cell(line, 'N').to_f,   
          pay_type:        sheet.cell(line, 'O'),
          user_id:         nil,
          user_name:       sheet.cell(line, 'P'),         
          modified_by:     nil, # sheet.cell(line, 'AR'),
          modified_name:   sheet.cell(line, 'Q'),
          modified_date:   sheet.cell(line, 'R').present? ? Date.strptime(sheet.cell(line, 'R'), '%m/%d/%Y') : nil,          
          modified_time:   sheet.cell(line, 'S'),
          cover:           sheet.cell(line, 'T').to_i,
          comment:         sheet.cell(line, 'U'),
          customer_id:     customer.present? ? customer.id : nil, 
          customer_name:   sheet.cell(line, 'V'),
          cc_name:         sheet.cell(line, 'W'),
          settle_time:     sheet.cell(line, 'X'),
          remarks:         sheet.cell(line, 'Y'),
          waiter_id:       waiter_id.present?  ? waiter_id  : nil 
        }        
        void_bill = VoidBill.unscoped.where(location_id: location.id, outlet_id: outlet.id, financial_year_id: fin_year.id, bill_no: bill_no, bill_type: bill_type,
          bill_date: bill_date).first_or_initialize                
        void_bill.update_attributes!(params) if void_bill.new_record?     
      end
    rescue Exception => e
      success = false
      msg = e.message + " in void bill at line no #{$line}"
    end      
    return success, msg
  end
  
  def self.change_step(from, to)
    unscoped.where(step: from).update_all(step: to)
  end
  
  #=["Bill_No", "Table_No", "Bill_Date", "Bill_Type", "Outlet", "LocationName", "Financial_Year_Name", "Bill_Time", "Wtr_No", "Wtr_Name", "Dis%", "Dis", "S_Tax", "Total", 
  #"Pay_Type", "User", "Mod_User", "Mod_Date", "Mod_Time", "Covers", "Comment", "Customer", "CC_Name", "Settle_Time", "Remarks"]

  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    begin
      raise "Please set proper header for void_bills sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Bill_No" ||
          sheet.cell(1, 'B').to_s.strip != "Table_No" || sheet.cell(1, 'C').to_s.strip != "Bill_Date" || sheet.cell(1, 'D').to_s.strip != "Bill_Type"   || 
          sheet.cell(1, 'E').to_s.strip != "Outlet"   || sheet.cell(1, 'F').to_s.strip != "LocationName" || sheet.cell(1, 'G').to_s.strip != "Financial_Year_Name"   || 
          sheet.cell(1, 'H').to_s.strip != "Bill_Time"|| sheet.cell(1, 'I').to_s.strip != "Wtr_No" || sheet.cell(1, 'J').to_s.strip != "Wtr_Name"  || 
          sheet.cell(1, 'K').to_s.strip != "Dis%"  || sheet.cell(1, 'L').to_s.strip != "Dis" || sheet.cell(1, 'M').to_s.strip != "S_Tax" || 
          sheet.cell(1, 'N').to_s.strip != "Total"      || sheet.cell(1, 'O').to_s.strip != "Pay_Type" || sheet.cell(1, 'P').to_s.strip != "User" || 
          sheet.cell(1, 'Q').to_s.strip != "Mod_User"|| sheet.cell(1, 'R').to_s.strip != "Mod_Date" || sheet.cell(1, 'S').to_s.strip != "Mod_Time" || 
          sheet.cell(1, 'T').to_s.strip != "Covers" ||  sheet.cell(1, 'U').to_s.strip != "Comment" || sheet.cell(1, 'V').to_s.strip != "Customer" || 
          sheet.cell(1, 'W').to_s.strip != "CC_Name" || sheet.cell(1, 'X').to_s.strip != "Settle_Time" || sheet.cell(1, 'Y').to_s.strip != "Remarks" 
      )    
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end
  
end