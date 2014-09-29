class Table < ActiveRecord::Base
  # attr_accessible :location, :outlet, :table_section_id, :t_name, :max_pax, :position, :inUse, :tax3app
  belongs_to   :location
  belongs_to   :outlet  
  belongs_to   :table_section
  
  validates     :location, :t_name, :position, presence: true
  validates_uniqueness_of :t_name,        scope: [:location, :position], case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Table Master Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        t_name    = sheet.cell(line, 'A').gsub("'", "")
        position  = sheet.cell(line, 'C').to_i
        outlet = location.outlets.where(name: sheet.cell(line, 'F')).first  unless sheet.cell(line, 'F').blank?
        table_section = location.table_sections.where(section: sheet.cell(line, 'D')).first unless sheet.cell(line, 'D').blank? 
        params = {
          outlet_id:         outlet.present? ? outlet.id : "",  
          table_section_id:  table_section.present? ? table_section.id : "",  
          max_pax:           sheet.cell(line, 'B').to_i,                    
          inUse:             sheet.cell(line, 'E') == 'false' ? false : true,        
          tax3app:           sheet.cell(line, 'G').gsub("'", ""),        
        }        
        table= location.tables.where(t_name: t_name, position: position).first_or_initialize                
        table.update_attributes!(params)        
      end
    rescue Exception => e
      success = false
      msg = e.message + " in table master at line no #{$line}"
    end
    return success, msg
  end 
  
  
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    # ["Table_Name", "Max_Pax", "Position", "Section", "InUse", "Outlet", "Tax3App", "LocationName"]
    begin
      raise "Please set proper header for table_master sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Table_Name" || 
          sheet.cell(1, 'B').to_s.strip != "Max_Pax" || 
          sheet.cell(1, 'C').to_s.strip != "Position" || sheet.cell(1, 'D').to_s.strip != "Section" || sheet.cell(1, 'E').to_s.strip != "InUse" || 
          sheet.cell(1, 'F').to_s.strip != "Outlet"  || sheet.cell(1, 'G').to_s.strip != "Tax3App"   || sheet.cell(1, 'H').to_s.strip != "LocationName")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 

end