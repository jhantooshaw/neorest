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
end
