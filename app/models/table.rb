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
        t_name    = sheet.cell(line, 'A').gsub("'", "")
        position  = sheet.cell(line, 'C').to_i
       # outlet = location.outlets.where(name: sheet.cell(line, 'F')).first  unless sheet.cell(line, 'F').blank?
        table_section = location.table_sections.where(section: sheet.cell(line, 'D')).first unless sheet.cell(line, 'D').blank? 
        params = {
       #   outlet_id:         outlet.present? ? outlet.id : "",  
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
      msg = e.message + " in table master"
    end
    return success, msg
  end  
end