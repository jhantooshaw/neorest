class Location < ActiveRecord::Base  
  #attr_accessible :client_id, :name, :address, :phone, :ip, :has_outlet
  belongs_to    :client
  has_many      :financial_years_locations
  has_many      :financial_years, through: :financial_years_locations
  has_many      :outlets
  has_many      :waiters
  has_many      :taxes
  has_many      :table_sections
  has_many      :tables
  has_many      :stewards
  has_many      :item_groups
  has_many      :item_sub_groups  
  has_many      :items
  has_many      :credit_cards
  has_many      :customers
  has_many      :settings
  has_many      :item_groups_kot_prints
  has_many      :footer_settings
  has_many      :bill_groups
  has_many      :combo_offers
  has_many      :remark_masters
  has_many      :combo_packages
  has_many      :bill_master_backups
  has_many      :adj_bill_master_backups
  has_many      :comp_bill_master_backups
  has_many      :void_bills
  has_many      :staffs
  
  
  has_many      :sale_analyses 
  
  
  validates     :name, :presence => true
  validates_uniqueness_of :name,        scope: [:client, :address], case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, current_client)
    success =  true
    msg = ""
    begin
      p "Location Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|        
        params = {
          phone:   sheet.cell(line, 'C').to_i,
          ip:      sheet.cell(line, 'D')                  
        }
        location = current_client.locations.where(:name => sheet.cell(line, 'A'), :address => sheet.cell(line, 'B')).first_or_initialize                
        location.update_attributes!(params)
      end
    rescue Exception => e
      success = false
      msg = e.message + " in location"
    end      
    return success, msg
  end  
end