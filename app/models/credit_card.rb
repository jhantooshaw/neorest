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
        cc_name = sheet.cell(line, 'A')
        params = {
          commision_amount: sheet.cell(line, 'B').to_f                 
        }        
        cc = location.credit_cards.where(cc_name: cc_name).first_or_initialize                
        cc.update_attributes!(params)
      end      
    rescue Exception => e
      success = false
      msg = e.message + " in credit card."
    end      
    return success, msg
  end  
end