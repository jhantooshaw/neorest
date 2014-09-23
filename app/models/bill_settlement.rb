class BillSettlement < ActiveRecord::Base
  belongs_to  :bill_master_backup
  belongs_to  :customer
  
  validates  :auto_no, :bill_master_backup_id, presence:  true
  validates_uniqueness_of :auto_no, scope: [:bill_master_backup_id], case_sensitive: false, message: "duplicate entry" 
  
  default_scope {where(step: 'imported')} 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Bill Settlememnt Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        auto_no       = sheet.cell(line, 'A').to_i
        bill_date     = sheet.cell(line, 'B')
        bill_no       = sheet.cell(line, 'C').to_i        
        bill_type     = sheet.cell(line, 'E')
        outlet_name   = sheet.cell(line, 'N')
        fin_year_name = sheet.cell(line, 'T')        
        fin_year      = location.financial_years.where(name: fin_year_name).first
        raise "Financial Year #{fin_year_name} is not found into database" if fin_year.blank?
        outlet = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found" if outlet.blank?        
        bill_master_backup = BillMasterBackup.unscoped.where(location_id: location.id, outlet_id: outlet.id, financial_year_id: fin_year.id, bill_no: bill_no,
          bill_date: bill_date, bill_type: bill_type).first   
        next if bill_master_backup.blank?  
        #raise "No Bill Master Entry For This Bill Settlement" if bill_master_backup.blank?  
        customer      = location.customers.where(c_name: sheet.cell(line, 'J')).first unless sheet.cell(line, 'J').blank?
        params = { 
          pay_type:       sheet.cell(line, 'F'), 
          pay_amount:     sheet.cell(line, 'G').to_f,  
          cc_name:        sheet.cell(line, 'H'), 
          cashier:        sheet.cell(line, 'I'), 
          customer_id:    customer.present? ? customer.id : nil, 
          customer_name:  sheet.cell(line, 'J'), 
          table_no:       sheet.cell(line, 'K'),  
          comment:        sheet.cell(line, 'L'),           
          tips:           sheet.cell(line, 'M').to_f, 
          room_no:        sheet.cell(line, 'O'), 
          hotel_date:     sheet.cell(line, 'P'), 
          manager_bit:    sheet.cell(line, 'S').to_s, 
          manager_date:   sheet.cell(line, 'R')
        }        
        bill_settlement = BillSettlement.unscoped.where(bill_master_backup_id: bill_master_backup.id, auto_no: auto_no).first_or_initialize                
        bill_settlement.update_attributes!(params) if bill_settlement.new_record? 
      end
    rescue Exception => e
      success = false
      msg = e.message + " in bill settlememnt at line no #{$line}"
    end      
    return success, msg
  end
  
  def self.change_step(from, to)
    unscoped.where(step: from).update_all(step: to)
  end 
  # ["AutoId", "Bill_Date", "Bill_No", "Bill_Amt", "Bill_Type", "Pay_Type", "Pay_Amt", "CC_Name", "Cashier", "Customer", 
  # "TableNo", "Comment", "Tips", "Outlet", "Room_No", "Hotel_Date", "ManagerBit", "ManagerDate", "LocationName", "Financial_Year_Name"]
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    begin
      raise "Please set proper header for bill_settlement sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "AutoId" ||
          sheet.cell(1, 'B').to_s.strip != "Bill_Date" || sheet.cell(1, 'C').to_s.strip != "Bill_No" || sheet.cell(1, 'D').to_s.strip != "Bill_Amt"   || 
          sheet.cell(1, 'E').to_s.strip != "Bill_Type" || sheet.cell(1, 'F').to_s.strip != "Pay_Type"|| sheet.cell(1, 'G').to_s.strip != "Pay_Amt"   || 
          sheet.cell(1, 'H').to_s.strip != "CC_Name"   || sheet.cell(1, 'I').to_s.strip != "Cashier" || sheet.cell(1, 'J').to_s.strip != "Customer"  || 
          sheet.cell(1, 'K').to_s.strip != "TableNo"   || sheet.cell(1, 'L').to_s.strip != "Comment" || sheet.cell(1, 'M').to_s.strip != "Tips" || 
          sheet.cell(1, 'N').to_s.strip != "Outlet"    || sheet.cell(1, 'O').to_s.strip != "Room_No" || sheet.cell(1, 'P').to_s.strip != "Hotel_Date" || 
          sheet.cell(1, 'Q').to_s.strip != "ManagerBit"|| sheet.cell(1, 'R').to_s.strip != "ManagerDate" ||sheet.cell(1, 'S').to_s.strip != "LocationName" || 
          sheet.cell(1, 'T').to_s.strip != "Financial_Year_Name")      
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end
  
end