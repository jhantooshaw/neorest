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
      2.upto(sheet.last_row) do |line|
        $line = line
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
          cost:             sheet.cell(line, 'AA').to_f, 
          open_item:        sheet.cell(line, 'AB') == 'false' ? false : (sheet.cell(line, 'AB') == 'true' ? true : nil)
        }        
        item = location.items.where(outlet_id: outlet.id, code_no: sheet.cell(line, 'A')).first_or_initialize                
        item.update_attributes!(params)
      end
    rescue Exception => e
      success = false
      msg = e.message + " in item at line no #{$line}"
    end      
    return success, msg
  end
  
  

  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #["Code_No", "Outlet", "Description", "Rate", "Rate2", "MRP", "Taxable", "Excisable", "Discountable", "Disable", "D_Sale", "S_Value", 
  #"Item_Group", "Item_Sub_Group", "Canceled_Qty", "Canceled_Amt", "Under", "Item_Group_KOT", "Service_Charge", "Event", "Alias", "LocationName", 
  #"KOT_Printer", "KOT_Printer_Position", "Bill_Group", "Sp_Item", "Cost", "Open_Item"]

    begin
      raise "Please set proper header for items sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Code_No" || 
          sheet.cell(1, 'B').to_s.strip != "Outlet" || 
          sheet.cell(1, 'C').to_s.strip != "Description" || sheet.cell(1, 'D').to_s.strip != "Rate" || sheet.cell(1, 'E').to_s.strip != "Rate2" || 
          sheet.cell(1, 'F').to_s.strip != "MRP"  || sheet.cell(1, 'G').to_s.strip != "Taxable"   || sheet.cell(1, 'H').to_s.strip != "Excisable" ||
          sheet.cell(1, 'I').to_s.strip != "Discountable"  || sheet.cell(1, 'J').to_s.strip != "Disable"   || sheet.cell(1, 'K').to_s.strip != "D_Sale" ||
          sheet.cell(1, 'L').to_s.strip != "S_Value"   || sheet.cell(1, 'M').to_s.strip != "Item_Group" || 
          sheet.cell(1, 'N').to_s.strip != "Item_Sub_Group"  || sheet.cell(1, 'O').to_s.strip != "Canceled_Qty"   || sheet.cell(1, 'P').to_s.strip != "Canceled_Amt" ||
          sheet.cell(1, 'Q').to_s.strip != "Under"   || sheet.cell(1, 'R').to_s.strip != "Item_Group_KOT" ||
          sheet.cell(1, 'S').to_s.strip != "Service_Charge"   || sheet.cell(1, 'T').to_s.strip != "Event" ||          
          sheet.cell(1, 'U').to_s.strip != "Alias"   || sheet.cell(1, 'V').to_s.strip != "LocationName" ||
          sheet.cell(1, 'W').to_s.strip != "KOT_Printer"   || sheet.cell(1, 'X').to_s.strip != "KOT_Printer_Position" ||
          sheet.cell(1, 'Y').to_s.strip != "Bill_Group"   || sheet.cell(1, 'Z').to_s.strip != "Sp_Item" ||
          sheet.cell(1, 'AA').to_s.strip != "Cost"   || sheet.cell(1, 'AB').to_s.strip != "Open_Item"
      )         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
    
  
end
