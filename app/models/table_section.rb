class TableSection < ActiveRecord::Base
  # attr_accessible :location, :outlet, :section, :amount
  belongs_to   :location
  belongs_to   :outlet  
  has_many     :tables
  
  validates     :location, :outlet, :section, presence: true
  validates_uniqueness_of :section,        scope: [:location, :outlet], case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Table Section Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        outlet_name = sheet.cell(line, 'C')
        outlet = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found into database" if outlet.blank?
        params = {
          amount:  sheet.cell(line, 'B').to_f        
        }        
        table_section = location.table_sections.where(section: sheet.cell(line, 'A'), outlet_id: outlet.id).first_or_initialize                
        table_section.update_attributes!(params)        
      end
    rescue Exception => e
      success = false
      msg = e.message + " in table section at line no #{$line}"
    end
    return success, msg
  end  
  
  

  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #===========["Section", "Sec_Amt", "Outlet", "LocationName"]
    begin
      raise "Please set proper header for table_section sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Section" || 
          sheet.cell(1, 'B').to_s.strip != "Sec_Amt" || sheet.cell(1, 'C').to_s.strip != "Outlet" || sheet.cell(1, 'D').to_s.strip != "LocationName")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
end