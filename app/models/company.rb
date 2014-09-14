class Company < ActiveRecord::Base
  
  belongs_to :client
  
  validates :client, :name, :address1,    :presence => true
  validates_uniqueness_of :name,        scope: [:client_id, :address1], case_sensitive: false, message: "duplicate entry"
  
  def self.import(sheet, client)
    success =  true
    msg = ""
    begin
      p "Company Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|        
        params = {
          address2:   sheet.cell(line, 'D'),
          address3:   sheet.cell(line, 'E'),
          address4:   sheet.cell(line, 'F'),
          address5:   sheet.cell(line, 'G'),
          phone:      sheet.cell(line, 'H').to_i.to_s,
          other:      sheet.cell(line, 'I'),
          start_date: sheet.cell(line, 'J'),
          end_date:   sheet.cell(line, 'K'),
        }
        company = client.companies.where(:name => sheet.cell(line, 'B'), :address1 => sheet.cell(line, 'C')).first_or_initialize                
        company.update_attributes!(params) 
        
        location = client.locations.where(:name => sheet.cell(line, 'B'), :address => sheet.cell(line, 'C')).first_or_initialize              
        location.save!
      end
    rescue Exception => e
      success = false
      msg = e.message + " in company"
    end      
    return success, msg
  end
end
