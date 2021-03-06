class StaffMenuSetting < ActiveRecord::Base
  belongs_to    :staff  
  validates     :staff_id, :menu, presence: true
  validates_uniqueness_of :menu, scope: [:staff_id], case_sensitive: false, message: "duplicate entry"
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "User Main Menu Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        staff_name  = sheet.cell(line, 'A')
        staff       = location.staffs.where(name: staff_name).first
        raise "Staff name #{staff_name} is not found" if staff.blank?
        params = {          
          is_visible: sheet.cell(line, 'C') == 'false' ? false : true          
        }
        staff_menu_setting = staff.staff_menu_settings.where(menu: sheet.cell(line, 'B')).first_or_initialize                
        staff_menu_setting.update_attributes!(params)      
      end
    rescue Exception => e
      success = false
      msg = e.message + " in user main menu at line no #{$line}"
    end      
    return success, msg
  end
  
  

  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #===========["Uname", "MainMenuName", "Visibility", "LocationName"]
    begin
      raise "Please set proper header for usermainmenu sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Uname" || 
          sheet.cell(1, 'B').to_s.strip != "MainMenuName" || sheet.cell(1, 'C').to_s.strip != "Visibility" || sheet.cell(1, 'D').to_s.strip != "LocationName")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
end
