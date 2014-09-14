class ComboPackage < ActiveRecord::Base
  belongs_to   :location
  validates     :location_id, :name,    presence: true
  validates_uniqueness_of :name,        scope: [:location_id], case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Combo Package Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        params = {
          is_active:          sheet.cell(line, 'C') == 'true' ? true : false, 
          linked_happy_hour:  sheet.cell(line, 'D') == 'true' ? true : false          
        }
        combo_pack = location.combo_packages.where(name: sheet.cell(line, 'B')).first_or_initialize                
        combo_pack.update_attributes!(params)
      end
    rescue Exception => e
      success = false
      msg = e.message + " in combo package"
    end      
    return success, msg
  end  
  
end
