class Item < ActiveRecord::Base
  #attr_accessible :location_id, :ig_name, :ig_tag, :order_kot 
  belongs_to   :location
  belongs_to   :outlet  
  belongs_to   :item_group
  belongs_to   :item_sub_group
  belongs_to   :bill_group  
  has_many     :bill_detail_backups
  has_many     :comp_bill_detail_backups
  
  validates     :code_no, :location_id, :outlet_id, presence: true
  validates_uniqueness_of :code_no,        scope: [:location_id, :outlet_id], case_sensitive: false, message: "duplicate entry" 
  
  #named_scope :in_item_group, lambda { |items| { :conditions => ['item_groups', forums.select(&:id).join(',')] }
  
  scope :all_items, lambda { |item_group_id| { :select => "id", :conditions => ['item_group_id = ?', item_group_id] }}
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Items Sheet Row: #{sheet.last_row}"
      @line = 0
      2.upto(sheet.last_row) do |line|
        @line = line
        outlet_name = sheet.cell(line, 'B')
        outlet = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found" if outlet.blank?        
        item_grp = location.item_groups.where(ig_name: sheet.cell(line, 'M')).first unless sheet.cell(line, 'M').blank?
        item_sub_grp = location.item_sub_groups.where(isg_name: sheet.cell(line, 'N')).first unless sheet.cell(line, 'N').blank?
        item_grps_kot = location.item_groups_kot_prints.where(name: sheet.cell(line, 'R')).first unless sheet.cell(line, 'R').blank?        
        bill_grp = location.bill_groups.where(name: sheet.cell(line, 'Y')).first unless sheet.cell(line, 'Y').blank?          
        params = { 
          description:      sheet.cell(line, 'C'),  
          rate:             sheet.cell(line, 'D').to_i, 
          rate2:            sheet.cell(line, 'E'), 
          mrp:              sheet.cell(line, 'F').to_f, 
          is_taxable:       sheet.cell(line, 'G') == 'false' ? false : true, 
          excisable:        sheet.cell(line, 'H'), 
          discountable:     sheet.cell(line, 'I'), 
          disable:          sheet.cell(line, 'J'),  
          dsale:            sheet.cell(line, 'K').to_i, 
          svalue:           sheet.cell(line, 'L').to_i, 
          item_group_id:    item_grp.present? ? item_grp.id : "",
          item_sub_group_id: item_sub_grp.present? ? item_sub_grp.id : "",
          canceled_qty:     sheet.cell(line, 'O').to_i, 
          canceled_amount:  sheet.cell(line, 'P').to_f, 
          under:            sheet.cell(line, 'Q'), 
          item_groups_kot_id: item_grps_kot.present? ? item_grps_kot.id : "",
          service_charge:   sheet.cell(line, 'S').to_i, 
          event:            sheet.cell(line, 'T'),
          i_alias:          sheet.cell(line, 'U'), 
          kot_printer:      sheet.cell(line, 'W'), 
          kot_printer_position: sheet.cell(line, 'X').gsub("'", "").to_i, 
          bill_group_id:    bill_grp.present? ? bill_grp.id : "",
          is_special:       sheet.cell(line, 'Z') == 'true' ? true : false,  
          open_item:        sheet.cell(line, 'Z') == 'false' ? false : (sheet.cell(line, 'Z') == 'true' ? true : nil)
        }        
        item = location.items.where(outlet_id: outlet.id, code_no: sheet.cell(line, 'A')).first_or_initialize                
        item.update_attributes!(params)
      end
    rescue Exception => e
      success = false
      msg = e.message + " in item at line no #{@line}"
    end      
    return success, msg
  end

    
  
end
