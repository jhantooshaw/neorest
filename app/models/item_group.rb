class ItemGroup < ActiveRecord::Base
  #attr_accessible :location_id, :ig_name, :ig_tag, :order_kot 
  belongs_to   :location
  has_many     :items
  
  validates     :location_id, :ig_name,    presence: true
  validates_uniqueness_of :ig_name,        scope: [:location_id], case_sensitive: false, message: "duplicate entry"
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Item Group Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        params = {
          order_kot:  sheet.cell(line, 'B').to_i, 
          ig_tag:     sheet.cell(line, 'C')          
        }
        item_group = location.item_groups.where(ig_name: sheet.cell(line, 'A')).first_or_initialize                
        item_group.update_attributes!(params)
      end
    rescue Exception => e
      success = false
      msg = e.message + " in item group at line no #{$line}"
    end      
    return success, msg
  end 
  
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #["Group_Name", "Order_KOT", "Tag", "LocationName"]

    begin
      raise "Please set proper header for item_groups sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Group_Name" || 
          sheet.cell(1, 'B').to_s.strip != "Order_KOT" || sheet.cell(1, 'C').to_s.strip != "Tag" || sheet.cell(1, 'D').to_s.strip != "LocationName")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
  
end