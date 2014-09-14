class Customer < ActiveRecord::Base
  belongs_to    :location  
  has_many      :bill_master_backups
  has_many      :adj_bill_master_backups
  has_many      :bill_settlements
  has_many      :comp_bill_master_backups
  has_many      :void_bills
  
  validates  :location, :membership_no, :presence => true
  validates_uniqueness_of :membership_no,  scope: [:location_id], case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Customer Sheet Row: #{sheet.last_row}"      
      2.upto(sheet.last_row) do |line|         
        params = {
          c_name:      sheet.cell(line, 'B'), 
          address1:    sheet.cell(line, 'C'), 
          address2:    sheet.cell(line, 'D') == "BLANK"  ? "" : sheet.cell(line, 'D'), 
          zipcode:     sheet.cell(line, 'E').to_i == 0   ? "" : sheet.cell(line, 'E').to_i.to_s, 
          phone1:      sheet.cell(line, 'F').to_i == 0   ? "" : sheet.cell(line, 'F').to_i.to_s, 
          phone2:      sheet.cell(line, 'G').to_i == 0   ? "" : sheet.cell(line, 'G').to_i.to_s, 
          mobile:      sheet.cell(line, 'H').to_i == 0   ? "" : sheet.cell(line, 'H').to_i.to_s, 
          fax:         sheet.cell(line, 'I').to_i == 0   ? "" : sheet.cell(line, 'I').to_i.to_s, 
          dob:         sheet.cell(line, 'J'), 
          ann:         sheet.cell(line, 'K'),           
          entry_date:  sheet.cell(line, 'L'),          
          email:       sheet.cell(line, 'M') == "BLANK"  ? "" : sheet.cell(line, 'M'), 
          dis_per:     sheet.cell(line, 'N').to_f, 
          order_date:  sheet.cell(line, 'Q'), 
          remarks:     sheet.cell(line, 'R'),           
          membership_no_manual: sheet.cell(line, 'S'),
          card_no:     sheet.cell(line, 'T')          
        }        
        customer = location.customers.where(membership_no: sheet.cell(line, 'A').to_i).first_or_initialize                
        customer.update_attributes!(params)
      end
    rescue Exception => e
      success = false
      msg = e.message + " in customer"
    end      
    return success, msg
  end    
end