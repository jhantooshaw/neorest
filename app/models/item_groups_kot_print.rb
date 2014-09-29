class ItemGroupsKotPrint < ActiveRecord::Base
  #attr_accessible :location_id, :name
  belongs_to   :location
  has_many     :items
  
  validates     :location_id, :name,    presence: true
  validates_uniqueness_of :name,        scope: [:location_id], case_sensitive: false, message: "duplicate entry"  
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Item Group Kot Print Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|   
        $line = line
        item_group_kot = location.item_groups_kot_prints.where(name: sheet.cell(line, 'A')).first_or_initialize                
        item_group_kot.save!
      end           
    rescue Exception => e
      success = false
      msg = e.message + " in item group kot print at line no #{$line}"
    end      
    return success, msg
  end  
  
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #===========["Group_Name", "LocationName"]
    begin
      raise "Please set proper header for item_groups_kot_print sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Group_Name" || 
          sheet.cell(1, 'B').to_s.strip != "LocationName" )         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 

end