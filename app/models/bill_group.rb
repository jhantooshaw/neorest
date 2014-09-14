class BillGroup < ActiveRecord::Base
  #attr_accessible :location_id, :name  
  belongs_to   :location
  has_many     :items
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Bill Group Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|    
        bill_group = location.bill_groups.where(name: sheet.cell(line, 'B')).first_or_initialize                
        bill_group.save!       
      end     
    rescue Exception => e
      success = false
      msg = e.message + " in bill group"
    end      
    return success, msg
  end  
end