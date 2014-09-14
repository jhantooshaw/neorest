class HappyHour < ActiveRecord::Base
  belongs_to   :location
  belongs_to   :outlet
  validates    :outlet, :happy_hour_cd,    presence: true
  validates_uniqueness_of :happy_hour_cd,        scope: [:outlet_id], case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Happy Hour Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        outlet_name = sheet.cell(line, 'E')
        outlet      = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found into database" if outlet.blank?        
        combo_pack = location.combo_packages.where(name: sheet.cell(line, 'D')).first unless sheet.cell(line, 'D').blank?
        params = {
          start_date:   sheet.cell(line, 'B'), 
          end_date:  sheet.cell(line, 'C'),
          combo_package_id: combo_pack.present? ? combo_pack.id : "", 
        }
        combo_pack = location.happy_hours.where(happy_hour_cd: sheet.cell(line, 'A').to_i, outlet: outlet.id).first_or_initialize                
        combo_pack.update_attributes!(params)
      end
    rescue Exception => e
      success = false
      msg = e.message + " in happy hour"
    end      
    return success, msg
  end  
  
end
