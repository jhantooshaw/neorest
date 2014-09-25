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
  
  

  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #===========["Wtr_No", "Wtr_Name", "Service_Ch", "Outlet", "LocationName"]
    begin
      raise "Please set proper header for waiter sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Wtr_No" || 
          sheet.cell(1, 'B').to_s.strip != "Wtr_Name" || sheet.cell(1, 'C').to_s.strip != "Service_Ch" || sheet.cell(1, 'D').to_s.strip != "Outlet" ||
          sheet.cell(1, 'E').to_s.strip != "LocationName")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
end