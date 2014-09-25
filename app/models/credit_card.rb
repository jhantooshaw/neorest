class CreditCard < ActiveRecord::Base
  #attr_accessible :location_id, :name, :commision_amount
  belongs_to    :location  
  validates     :location, :cc_name,       presence: true
  validates_uniqueness_of :cc_name,        scope: [:location], case_sensitive: false, message: "duplicate entry"   
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Credit Card Sheet Row: #{sheet.last_row}"      
      2.upto(sheet.last_row) do |line|
        $line = line
        cc_name = sheet.cell(line, 'A')
        params = {
          commision_amount: sheet.cell(line, 'B').to_f                 
        }        
        cc = location.credit_cards.where(cc_name: cc_name).first_or_initialize                
        cc.update_attributes!(params)
      end      
    rescue Exception => e
      success = false
      msg = e.message + " in credit card at line no #{$line}"
    end      
    return success, msg
  end  
  
 
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #["CreditCard_Name", "Commision_Amt", "LocationName"]
    begin
      raise "Please set proper header for CreditCard_Master sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "CreditCard_Name" || 
          sheet.cell(1, 'B').to_s.strip != "Commision_Amt" || sheet.cell(1, 'C').to_s.strip != "LocationName")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
end