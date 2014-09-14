class StaffSubMenuSetting < ActiveRecord::Base
  belongs_to     :staff
  
  validates     :staff_id, :sub_menu, presence: true
  validates_uniqueness_of :sub_menu, scope: [:staff_id], case_sensitive: false, message: "duplicate entry"
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "User Validation Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        staff_name  = sheet.cell(line, 'A')
        staff       = location.staffs.where(name: staff_name).first
        raise "Staff name #{staff_name} is not found" if staff.blank?
        params = { 
          is_add:     sheet.cell(line, 'C') == 'false' ? false : true, 
          is_delete:  sheet.cell(line, 'D') == 'false' ? false : true, 
          is_find:    sheet.cell(line, 'E') == 'false' ? false : true, 
          is_edit:    sheet.cell(line, 'F') == 'false' ? false : true, 
          is_visible: sheet.cell(line, 'G') == 'false' ? false : true
          
        }
        staff_sub_menu_setting = staff.staff_sub_menu_settings.where(sub_menu: sheet.cell(line, 'B')).first_or_initialize                
        staff_sub_menu_setting.update_attributes!(params)      
      end
    rescue Exception => e
      success = false
      msg = e.message + " in user validation at line no #{$line}"
    end      
    return success, msg
  end
  
end
