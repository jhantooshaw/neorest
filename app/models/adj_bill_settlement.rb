class AdjBillSettlement < ActiveRecord::Base
  belongs_to  :adj_bill_master_backup
  belongs_to  :customer
  
  validates  :auto_no, :adj_bill_master_backup_id, presence:  true
  validates_uniqueness_of :auto_no, scope: [:adj_bill_master_backup_id], case_sensitive: false, message: "duplicate entry" 
  
  default_scope {where(step: 'imported')} 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Adj Bill Settlememnt Row: #{sheet.last_row}"
      @line = 0
      2.upto(sheet.last_row) do |line|
        @line = line
        auto_no       = sheet.cell(line, 'A').to_i
        bill_date     = sheet.cell(line, 'B')
        bill_no       = sheet.cell(line, 'C').to_i        
        bill_type     = sheet.cell(line, 'E')
        outlet_name   = sheet.cell(line, 'N')
        fin_year_name = sheet.cell(line, 'T')        
        fin_year      = location.financial_years.where(name: fin_year_name).first
        raise "Financial year #{fin_year_name} is not found into database" if fin_year.blank?
        outlet = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found" if outlet.blank?        
        adj_bill_master_backup = AdjBillMasterBackup.unscoped.where(location_id: location.id, outlet_id: outlet.id, financial_year_id: fin_year.id, bill_no: bill_no,
          bill_date: bill_date, bill_type: bill_type).first
        next if adj_bill_master_backup.blank?  
        #raise "No adj bill master is found" if adj_bill_master_backup.blank?  
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
        adj_bill_settlement = AdjBillSettlement.unscoped.where(adj_bill_master_backup_id: adj_bill_master_backup.id, auto_no: auto_no).first_or_initialize                
        adj_bill_settlement.update_attributes!(params) if adj_bill_settlement.new_record? 
      end
    rescue Exception => e
      success = false
      msg = e.message + " in adj bill settlememnt at line no #{@line}"
    end      
    return success, msg
  end 
  
  def self.change_step(from, to)
    unscoped.where(step: from).update_all(step: to)
  end
end