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
        $line = line
        params = {
          is_active:          sheet.cell(line, 'C') == 'true' ? true : false, 
          linked_happy_hour:  sheet.cell(line, 'D') == 'true' ? true : false          
        }
        combo_pack = location.combo_packages.where(name: sheet.cell(line, 'B')).first_or_initialize                
        combo_pack.update_attributes!(params)
      end
    rescue Exception => e
      success = false
      msg = e.message + " in combo package at line no #{$line}"
    end      
    return success, msg
  end  
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
  #===========["PackageCD", "PackageName", "Active", "LinkedToHappyHour"]
    begin
      raise "Please set proper header for combopackage sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "PackageCD" || 
          sheet.cell(1, 'B').to_s.strip != "PackageName" || sheet.cell(1, 'C').to_s.strip != "Active" || sheet.cell(1, 'D').to_s.strip != "LinkedToHappyHour")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
  
end
