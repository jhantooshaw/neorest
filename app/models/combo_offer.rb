class ComboOffer < ActiveRecord::Base 
  #attr_accessible :location_id, :outlet_id, :combo_cd, :combo_code_no, :combo_desc, :combo_qty, :code_no_offer, :desc_offer, :qty_offer, 
  #:start_date, :end_date, :temp_date  
  
  belongs_to   :location
  belongs_to   :outlet  
  
  validates     :location_id, :outlet_id, :combo_code_no, :code_no_offer, presence: true
  validates_uniqueness_of :combo_code_no,        scope: [:location_id, :outlet_id, :code_no_offer], case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Combo Offer Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        outlet_name = sheet.cell(line, 'K')
        outlet      = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found into database" if outlet.blank?
        combo_pack    = location.combo_packages.where(name: sheet.cell(line, 'M')).first unless sheet.cell(line, 'M').blank?
        combo_code_no = sheet.cell(line, 'B')
        code_no_offer = sheet.cell(line, 'E')
        params = { 
          combo_cd:     sheet.cell(line, 'A').to_i,
          combo_desc:   sheet.cell(line, 'C'), 
          combo_qty:    sheet.cell(line, 'D'),
          desc_offer:   sheet.cell(line, 'F'), 
          qty_offer:    sheet.cell(line, 'G'), 
          start_date:   sheet.cell(line, 'H'), 
          end_date:     sheet.cell(line, 'I'), 
          temp_data:    sheet.cell(line, 'J'),           
          combo_package_id: combo_pack.present? ? combo_pack.id : ""         
        }
        combo_offer = location.combo_offers.where(outlet_id: outlet.id, combo_code_no: combo_code_no, code_no_offer: code_no_offer).first_or_initialize                
        combo_offer.update_attributes!(params)      
      end
    rescue Exception => e
      success = false
      msg = e.message + " in combo offer"
    end      
    return success, msg
  end  
end