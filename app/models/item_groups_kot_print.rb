class ItemGroupsKotPrint < ActiveRecord::Base
  #attr_accessible :location_id, :name
  belongs_to :location
  
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
end