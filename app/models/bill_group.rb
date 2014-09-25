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
        $line = line
        bill_group = location.bill_groups.where(name: sheet.cell(line, 'B')).first_or_initialize                
        bill_group.save!       
      end     
    rescue Exception => e
      success = false
      msg = e.message + " in bill group at line no #{$line}"
    end      
    return success, msg
  end 

  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #=["AutoId", "BillGroupName", "LocationName"]

    begin
      raise "Please set proper header for bill_group sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "AutoId" || 
          sheet.cell(1, 'B').to_s.strip != "BillGroupName" || sheet.cell(1, 'C').to_s.strip != "LocationName")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
end