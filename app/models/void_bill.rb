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
        waiter_id    = sheet.cell(line, 'H').to_i unless sheet.cell(line, 'I').blank?
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
end