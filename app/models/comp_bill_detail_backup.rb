class CompBillDetailBackup < ActiveRecord::Base
  belongs_to  :comp_bill_master_backup
  belongs_to  :item
  
  validates   :comp_bill_master_backup_id, :item_id, :auto_no, presence: true 
  
  default_scope {where(step: 'imported')}
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Comp Bill Detail Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        auto_no       = sheet.cell(line, 'A').to_i
        bill_no       = sheet.cell(line, 'C').to_i
        bill_date     = sheet.cell(line, 'D')
        outlet_name   = sheet.cell(line, 'O')
        fin_year_name = sheet.cell(line, 'S')
        fin_year      = location.financial_years.where(name: fin_year_name).first
        raise "Financial Year #{fin_year_name} is not found into database" if fin_year.blank?
        outlet = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found" if outlet.blank?        
        comp_bill_master_backup = CompBillMasterBackup.unscoped.where(location_id: location.id, outlet_id: outlet.id, financial_year_id: fin_year.id, bill_no: bill_no,
          bill_date: bill_date).first
        raise "Comp bill master is not found" if comp_bill_master_backup.blank?             
        item = location.items.where(code_no: sheet.cell(line, 'E')).first
        raise "Item code #{sheet.cell(line, 'E')} is not found" if item.blank?       
        params = { 
          serial_no:       sheet.cell(line, 'B').to_i,  
          item_id:         item.id, 
          rate:            sheet.cell(line, 'G').to_f,  
          qty:             sheet.cell(line, 'H').to_i, 
          amount:          sheet.cell(line, 'I').to_f, 
          quety:           sheet.cell(line, 'J') == 'false' ? false : (sheet.cell(line, 'J') == 'true' ? true : nil), 
          canceled:        sheet.cell(line, 'K'),           
          excisable:       sheet.cell(line, 'L'), 
          excise_amount:   sheet.cell(line, 'M').to_f, 
          mrp:             sheet.cell(line, 'N').to_f,
          combo_parent:    sheet.cell(line, 'P'), 
          kot_time:        sheet.cell(line, 'Q')
         
        }        
        comp_bill_detail_backup = CompBillDetailBackup.unscoped.where(comp_bill_master_backup_id: comp_bill_master_backup.id, auto_no: auto_no).first_or_initialize                
        comp_bill_detail_backup.update_attributes!(params) if comp_bill_detail_backup.new_record? 
      end
    rescue Exception => e
      success = false
      msg = e.message + " in comp bill detail backup at line no #{$line}"
    end      
    return success, msg
  end  
  
  def self.change_step(from, to)
    unscoped.where(step: from).update_all(step: to)
  end  
  
  #["Auto_No", "Serial_No", "Bill_No", "Bill_Date", "Code_No", "Description", "Rate", "Qty", "Amt", "Quety", "Canceled", "Excisable", "Excise_Amt", "MRP", 
  #"Outlet", "ComboParent", "KOT_Time", "LocationName", "Financial_Year_Name"]
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    begin
      raise "Please set proper header for comp_bill_detail_backup sheet in excel file" if sheet.last_row > 1 && (
        sheet.cell(1, 'A').to_s.strip != "Auto_No" || sheet.cell(1, 'B').to_s.strip != "Serial_No" || 
          sheet.cell(1, 'C').to_s.strip != "Bill_No" || sheet.cell(1, 'D').to_s.strip != "Bill_Date" || sheet.cell(1, 'E').to_s.strip != "Code_No" || 
          sheet.cell(1, 'F').to_s.strip != "Description"  || sheet.cell(1, 'G').to_s.strip != "Rate"   || sheet.cell(1, 'H').to_s.strip != "Qty" || 
          sheet.cell(1, 'I').to_s.strip != "Amt"     || sheet.cell(1, 'J').to_s.strip != "Quety"       || sheet.cell(1, 'K').to_s.strip != "Canceled" ||
          sheet.cell(1, 'L').to_s.strip != "Excisable" || sheet.cell(1, 'M').to_s.strip != "Excise_Amt" || sheet.cell(1, 'N').to_s.strip != "MRP" ||
          sheet.cell(1, 'O').to_s.strip != "Outlet"   || sheet.cell(1, 'P').to_s.strip != "ComboParent"       || sheet.cell(1, 'Q').to_s.strip != "KOT_Time" ||
          sheet.cell(1, 'R').to_s.strip != "LocationName"|| sheet.cell(1, 'S').to_s.strip != "Financial_Year_Name"
      )         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end
  
end
