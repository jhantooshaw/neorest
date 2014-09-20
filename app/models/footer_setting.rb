class FooterSetting < ActiveRecord::Base  
  #attr_accessible :location, :outlet, :header, :footer_one, :footer_two, :footer_three, :footer_four  
  belongs_to   :location
  belongs_to   :outlet
  
  validates     :header_id, :presence => true
  validates_uniqueness_of :header_id,        scope: [:location, :outlet], case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Footer Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        outlet_name = sheet.cell(line, 'G')
        outlet = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found into database" if outlet.blank?
        params = {
          header:       sheet.cell(line, 'B'), 
          footer_one:   sheet.cell(line, 'C'), 
          footer_two:   sheet.cell(line, 'D'), 
          footer_three: sheet.cell(line, 'E'), 
          footer_four:  sheet.cell(line, 'F')          
        }        
        footer_setting = location.footer_settings.where(header_id: sheet.cell(line, 'A').to_i, outlet_id: outlet.id).first_or_initialize                
        footer_setting.update_attributes!(params)        
      end
    rescue Exception => e
      success = false
      msg = e.message + " in bill footer setting at line no #{$line}"
    end
    return success, msg
  end  
end