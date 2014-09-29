class Outlet < ActiveRecord::Base  
  #attr_accessible :name, :is_location  
  belongs_to    :location  
  has_many      :waiters
  has_one       :tax
  has_many      :table_sections
  has_many      :stewards  
  has_many      :items
  has_one       :setting
  has_many      :item_groups_kot_prints
  has_many      :footer_settings
  has_many      :combo_offers
  has_many      :bill_master_backups
  has_many      :adj_bill_master_backups
  has_many      :comp_bill_master_backups
  has_many      :void_bills
  has_many      :staffs
  has_many      :tables
  
   
  has_many      :sale_analyses
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Outlet Sheet Row: #{sheet.last_row}"
      unless sheet.last_row <= 1
        2.upto(sheet.last_row) do |line|
          $line = line
          outlet = location.outlets.where(name: sheet.cell(line, 'B')).first_or_initialize                
          outlet.save!
        end
      else
        location.outlets.create!(name: location.name, is_location: true) if location.outlets.blank?
      end      
    rescue Exception => e
      success = false
      msg = e.message + " in outlet at line no #{$line}"
    end         
    return success, msg
  end
  
  

    def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #["Outlet_Id", "Outlet_Name", "LocationName"]
    begin
      raise "Please set proper header for outlet_master sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Outlet_Id" || 
          sheet.cell(1, 'B').to_s.strip != "Outlet_Name" || sheet.cell(1, 'C').to_s.strip != "LocationName")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
end