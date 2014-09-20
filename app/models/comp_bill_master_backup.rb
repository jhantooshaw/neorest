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
        waiter_id    = sheet.cell(line, 'H').to_i unless sheet.cell(line, 'H').blank?
        steward_id   = sheet.cell(line, 'J').to_i if sheet.cell(line, 'J').present? && sheet.cell(line, 'J').to_i != 0
        customer     = location.customers.where(c_name: sheet.cell(line, 'U')).first unless sheet.cell(line, 'U').blank?       
        
        bill_no      = sheet.cell(line, 'A').to_i
        bill_date    = sheet.cell(line, 'C')
        
        params = { 
          table_no:        sheet.cell(line, 'B'),
          bill_time:       sheet.cell(line, 'G'),
          total:           sheet.cell(line, 'L').to_f,       
          user_id:         nil,
          user_name:       sheet.cell(line, 'M'),         
          modified_by:     nil, # sheet.cell(line, 'AR'),
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
          waiter_id:       waiter_id.present?  ? waiter_id  : nil,        
          steward_id:      steward_id.present? ? steward_id : nil  
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
  
end