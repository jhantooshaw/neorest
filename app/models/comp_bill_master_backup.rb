class CompBillMasterBackup < ActiveRecord::Base
  belongs_to :location
  belongs_to :financial_year
  belongs_to :outlet
  belongs_to :waiter
  belongs_to :steward
  belongs_to :tax
  belongs_to :customer
  
  has_many   :comp_bill_detail_backups,          dependent: :destroy
  
  validates  :bill_no, :bill_date, :location, :outlet, :financial_year, presence:  true
  validates_uniqueness_of :bill_no, scope: [:bill_date, :location, :outlet, :financial_year], case_sensitive: false, message: "duplicate entry" 
  
  default_scope {where(step: 'imported')}
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Comp Bill Master Backup Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        outlet_name = sheet.cell(line, 'D')
        outlet      = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found into database" if outlet.blank?
        fin_year_name = sheet.cell(line, 'F')
        fin_year      = location.financial_years.where(name: fin_year_name).first
        raise "Financial Year #{fin_year_name} is not found into database" if fin_year.blank?       
        waiter       = location.waiters.where(w_no: sheet.cell(line, 'H').to_i).first if sheet.cell(line, 'H').present? && sheet.cell(line, 'H').to_i != 0
        steward      = location.waiters.where(s_no: sheet.cell(line, 'J').to_i).first if sheet.cell(line, 'J').present? && sheet.cell(line, 'J').to_i != 0
        staff        = location.staffs.where(name: sheet.cell(line, 'M')).first unless sheet.cell(line, 'M').blank?       
        staff_mod    = location.staffs.where(name: sheet.cell(line, 'N')).first unless sheet.cell(line, 'N').blank?  
        customer     = location.customers.where(c_name: sheet.cell(line, 'U')).first unless sheet.cell(line, 'U').blank?       
        
        bill_no      = sheet.cell(line, 'A').to_i
        bill_date    = sheet.cell(line, 'C')
        
        params = { 
          table_no:        sheet.cell(line, 'B'),
          bill_time:       sheet.cell(line, 'G'),
          total:           sheet.cell(line, 'L').to_f,       
          staff_id:        staff.present?  ? staff.id  : nil,
          staff_name:      sheet.cell(line, 'M'),         
          modified_by:     staff_mod.present?  ? staff_mod.id  : nil,
          modified_name:   sheet.cell(line, 'N'),
          modified_date:   sheet.cell(line, 'O').present? ? Date.strptime(sheet.cell(line, 'O'), '%m/%d/%Y') : nil,
          comment:         sheet.cell(line, 'P'),
          canceled:        sheet.cell(line, 'Q'),
          exciseable_amount:   sheet.cell(line, 'R').to_f,
          excise_amount:   sheet.cell(line, 'S').to_f,
          cover:           sheet.cell(line, 'T').to_i,          
          customer_id:     customer.present? ? customer.id : nil, 
          customer_name:   sheet.cell(line, 'U'),
          room_no:         sheet.cell(line, 'V'),
          hotel_date:      sheet.cell(line, 'W'),
          waiter_id:       waiter.present?  ? waiter.id  : nil,        
          steward_id:      steward.present? ? steward.id : nil 
        }
        
        comp_bill_master_backup = CompBillMasterBackup.unscoped.where(location_id: location.id, outlet_id: outlet.id, financial_year_id: fin_year.id, bill_no: bill_no,
          bill_date: bill_date).first_or_initialize                
        comp_bill_master_backup.update_attributes!(params) if comp_bill_master_backup.new_record?    
      end
    rescue Exception => e
      success = false
      msg = e.message + " in comp bill master backup at line no #{$line}"
    end      
    return success, msg
  end
  
  def self.change_step(from, to)
    unscoped.where(step: from).update_all(step: to)
  end
  
  #["Bill_No", "Table_No", "Bill_Date", "Outlet", "LocationName", "Financial_Year_Name", "Bill_Time", "Wtr_No", "Wtr_Name", "Stew_No", 
  #"Stew_Name", "Total", "User", "Mod_User", "Mod_Date", "Comment", "Canceled", "Exciseable_Amt", "Excise_Amt", "Covers", "Customer", "Room_No", 
  #"Hotel_Date"]
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    begin
      raise "Please set proper header for comp_bill_master_backup sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Bill_No" ||
          sheet.cell(1, 'B').to_s.strip != "Table_No" || sheet.cell(1, 'C').to_s.strip != "Bill_Date" || sheet.cell(1, 'D').to_s.strip != "Outlet"   || 
          sheet.cell(1, 'E').to_s.strip != "LocationName"   || sheet.cell(1, 'F').to_s.strip != "Financial_Year_Name" || sheet.cell(1, 'G').to_s.strip != "Bill_Time"   || 
          sheet.cell(1, 'H').to_s.strip != "Wtr_No"|| sheet.cell(1, 'I').to_s.strip != "Wtr_Name" || sheet.cell(1, 'J').to_s.strip != "Stew_No"  || 
          sheet.cell(1, 'K').to_s.strip != "Stew_Name"  || sheet.cell(1, 'L').to_s.strip != "Total" || sheet.cell(1, 'M').to_s.strip != "User" || 
          sheet.cell(1, 'N').to_s.strip != "Mod_User"      || sheet.cell(1, 'O').to_s.strip != "Mod_Date" || sheet.cell(1, 'P').to_s.strip != "Comment" || 
          sheet.cell(1, 'Q').to_s.strip != "Canceled"|| sheet.cell(1, 'R').to_s.strip != "Exciseable_Amt" || sheet.cell(1, 'S').to_s.strip != "Excise_Amt" || 
          sheet.cell(1, 'T').to_s.strip != "Covers" ||  sheet.cell(1, 'U').to_s.strip != "Customer" || sheet.cell(1, 'V').to_s.strip != "Room_No" || 
          sheet.cell(1, 'W').to_s.strip != "Hotel_Date"           
      )    
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end

  
end