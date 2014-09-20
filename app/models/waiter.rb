class Waiter < ActiveRecord::Base
  belongs_to    :location
  belongs_to    :outlet  
  has_many      :bill_master_backups
  has_many      :adj_bill_master_backups
  has_many      :comp_bill_master_backups
  has_many      :void_bills
  
  validates :location, presence: true
  #validates :w_no, uniqueness: {scope: :location_id}, presence: true
  validates_uniqueness_of :w_no,        scope: :location_id, case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Waiter Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line        
        outlet = location.outlets.where(name: sheet.cell(line, 'D')).first  unless sheet.cell(line, 'D').blank?
        params = {
          outlet_id:      outlet.present? ? outlet.id : "",           
          w_name:         sheet.cell(line, 'B'),                    
          service_charge: sheet.cell(line, 'C')       
        }        
        waiter = location.waiters.where(w_no: sheet.cell(line, 'A').to_i).first_or_initialize                
        waiter.update_attributes!(params)        
      end
    rescue Exception => e
      success = false
      msg = e.message + " in waiter at line no #{$line}"
    end
    return success, msg
  end   
end