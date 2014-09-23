class BillDetailBackup < ActiveRecord::Base
  belongs_to  :bill_master_backup
  belongs_to  :item
  
  validates   :bill_master_backup_id, :item_id, :auto_no, presence: true
  
  default_scope {where(step: 'imported')}  
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Bill Detail Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        auto_no      = sheet.cell(line, 'A').to_i
        bill_no      = sheet.cell(line, 'C').to_i
        bill_date    = sheet.cell(line, 'D')
        bill_type    = sheet.cell(line, 'E')
        outlet_name  = sheet.cell(line, 'F')
        fin_year_name = sheet.cell(line, 'AB')
        fin_year      = location.financial_years.where(name: fin_year_name).first
        raise "Financial Year #{fin_year_name} is not found into database" if fin_year.blank?
        outlet = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found" if outlet.blank? 
        bill_master_backup = BillMasterBackup.unscoped.where(location_id: location.id, outlet_id: outlet.id, financial_year_id: fin_year.id, bill_no: bill_no,
          bill_date: bill_date, bill_type: bill_type).first        
        raise "No Bill Master Entry For This Bill Detail" if bill_master_backup.blank?             
        item = location.items.where(code_no: sheet.cell(line, 'G')).first
        raise "Item code #{sheet.cell(line, 'G')} is not found" if item.blank?       
        params = { 
          serial_no:       sheet.cell(line, 'B').to_i,  
          item_id:         item.id, 
          rate:            sheet.cell(line, 'I').to_f,  
          qty:             sheet.cell(line, 'J').to_i, 
          amount:          sheet.cell(line, 'K').to_f, 
          excise_amount:   sheet.cell(line, 'L').to_f, 
          taxable:         sheet.cell(line, 'M'), 
          excisable:       sheet.cell(line, 'N'),  
          discountable:    sheet.cell(line, 'O'),           
          quety:           sheet.cell(line, 'P') == 'false' ? false : (sheet.cell(line, 'P') == 'true' ? true : nil) , 
          tax:             sheet.cell(line, 'Q').to_f, 
          total:           sheet.cell(line, 'R').to_f, 
          canceled:        sheet.cell(line, 'S'), 
          under:           sheet.cell(line, 'T'), 
          add_qty:         sheet.cell(line, 'U').to_i,  
          kot:             sheet.cell(line, 'V'), 
          kot_time:        sheet.cell(line, 'W'), 
          mrp:             sheet.cell(line, 'X').to_f, 
          s_charge:        sheet.cell(line, 'Y').to_f, 
          combo_parent:    sheet.cell(line, 'Z'), 
        }        
        bill_detail_backup = BillDetailBackup.unscoped.where(bill_master_backup_id: bill_master_backup.id, auto_no: auto_no).first_or_initialize                
        bill_detail_backup.update_attributes!(params) if bill_detail_backup.new_record? 
      end
    rescue Exception => e
      success = false
      msg = e.message + " in Bill Detail Backup at line no #{$line}"
    end      
    return success, msg
  end 
  
  def self.change_step(from, to)
    unscoped.where(step: from).update_all(step: to)
  end  
  
  #["Auto_No", "Serial_No", "Bill_No", "Bill_Date", "Bill_Type", "Outlet", "Code_No", "Description", "Rate", "Qty", 
  #"Amt", "Excise_Amt", "Taxable", "Excisable", "Discountable", "Quety", "Tax", "Total", "Canceled", "Under", "Add_Qty", "Kot", "KOT_Time", 
  #"MRP", "SCharge", "ComboParent", "LocationName", "Financial_Year_Name"]
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    begin
      raise "Please set proper header for bill_detail_backup sheet in excel file" if sheet.last_row > 1 && (
        sheet.cell(1, 'A').to_s.strip != "Auto_No" || sheet.cell(1, 'B').to_s.strip != "Serial_No" || 
          sheet.cell(1, 'C').to_s.strip != "Bill_No" || sheet.cell(1, 'D').to_s.strip != "Bill_Date" || sheet.cell(1, 'E').to_s.strip != "Bill_Type" || 
          sheet.cell(1, 'F').to_s.strip != "Outlet"  || sheet.cell(1, 'G').to_s.strip != "Code_No"   || sheet.cell(1, 'I').to_s.strip != "Rate" || 
          sheet.cell(1, 'J').to_s.strip != "Qty"     || sheet.cell(1, 'K').to_s.strip != "Amt"       || sheet.cell(1, 'L').to_s.strip != "Excise_Amt" ||
          sheet.cell(1, 'M').to_s.strip != "Taxable" || sheet.cell(1, 'N').to_s.strip != "Excisable" || sheet.cell(1, 'O').to_s.strip != "Discountable" ||
          sheet.cell(1, 'P').to_s.strip != "Quety"   || sheet.cell(1, 'Q').to_s.strip != "Tax"       || sheet.cell(1, 'R').to_s.strip != "Total" ||
          sheet.cell(1, 'S').to_s.strip != "Canceled"|| sheet.cell(1, 'T').to_s.strip != "Under"     || sheet.cell(1, 'U').to_s.strip != "Add_Qty" ||
          sheet.cell(1, 'V').to_s.strip != "Kot"     || sheet.cell(1, 'W').to_s.strip != "KOT_Time"  || sheet.cell(1, 'X').to_s.strip != "MRP" ||
          sheet.cell(1, 'Y').to_s.strip != "SCharge" || sheet.cell(1, 'Z').to_s.strip != "ComboParent"|| sheet.cell(1, 'AA').to_s.strip != "LocationName" ||
          sheet.cell(1, 'AB').to_s.strip != "Financial_Year_Name")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end

  
end