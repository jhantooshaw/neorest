class Staff < ActiveRecord::Base  
  belongs_to   :location
  belongs_to   :outlet
  
  has_many     :staff_menu_settings
  has_many     :staff_sub_menu_settings
  
  validates     :location_id, :name, :encrypted_password, presence: true
  validates_uniqueness_of :name, scope: [:location_id], case_sensitive: false, message: "duplicate entry"
  
  #before_save :encrypt_password
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "User Master Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        outlet_name = sheet.cell(line, 'C')
        outlet      = location.outlets.where(name: outlet_name).first
        params = { 
          encrypted_password:     sheet.cell(line, 'B'),
          outlet_id:   outlet.present? ? outlet.id : nil        
        }
        staff = location.staffs.where(name: sheet.cell(line, 'A')).first_or_initialize                
        staff.update_attributes!(params)      
      end
    rescue Exception => e
      success = false
      msg = e.message + " in user master at line no #{$line}"
    end      
    return success, msg
  end  

  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #  ===========["User_Name", "Password1", "Outlet", "LocationName"]
    begin
      raise "Please set proper header for user_master sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "User_Name" || 
          sheet.cell(1, 'B').to_s.strip != "Password1" || sheet.cell(1, 'C').to_s.strip != "Outlet" || sheet.cell(1, 'D').to_s.strip != "LocationName")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
  
  def encrypt_password
    self.encrypted_password = password_digest(encrypted_password)
  end
  
  
  
  protected
  def password_digest(password)
    Devise.bcrypt(self.class, password)
  end
end