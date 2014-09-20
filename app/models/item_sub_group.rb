class ItemSubGroup < ActiveRecord::Base
  #attr_accessible :location_id, :isg_name
  belongs_to   :location
  has_many     :items
  
  validates    :location_id, :isg_name, :presence => true
  validates_uniqueness_of :isg_name,        scope: [:location_id], case_sensitive: false, message: "duplicate entry"   
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Item Sub Group Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        item_sub_group = location.item_sub_groups.where(isg_name: sheet.cell(line, 'A')).first_or_initialize                
        item_sub_group.save!
      end     
    rescue Exception => e
      success = false
      msg = e.message + " in item sub group at line no #{$line}"
    end      
    return success, msg
  end   
  
 
  
end