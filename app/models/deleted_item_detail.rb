class DeletedItemDetail < ActiveRecord::Base
  
  
  
  # ["Bill_No", "Bill_Date", "Code_No", "Table_No", "KOT_No", "Description", "Rate", "Qty", "Amt", "Delete_Time", "Remarks", "MRP", 
  # "Cashier", "Bill_Type", "Outlet", "LocationName", "Financial_Year_Name", "KOT_Time"]

  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    begin
      raise "Please set proper header for deleted_item_detail sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Bill_No" ||
          sheet.cell(1, 'B').to_s.strip != "Bill_Date" || sheet.cell(1, 'C').to_s.strip != "Code_No" || sheet.cell(1, 'D').to_s.strip != "Table_No"   || 
          sheet.cell(1, 'E').to_s.strip != "KOT_No"   || sheet.cell(1, 'F').to_s.strip != "Description" || sheet.cell(1, 'G').to_s.strip != "Rate"   || 
          sheet.cell(1, 'H').to_s.strip != "Qty"|| sheet.cell(1, 'I').to_s.strip != "Amt" || sheet.cell(1, 'J').to_s.strip != "Delete_Time"  || 
          sheet.cell(1, 'K').to_s.strip != "Remarks"  || sheet.cell(1, 'L').to_s.strip != "MRP" || sheet.cell(1, 'M').to_s.strip != "Cashier" || 
          sheet.cell(1, 'N').to_s.strip != "Bill_Type"      || sheet.cell(1, 'O').to_s.strip != "Outlet" || sheet.cell(1, 'P').to_s.strip != "LocationName" || 
          sheet.cell(1, 'Q').to_s.strip != "Financial_Year_Name"|| sheet.cell(1, 'R').to_s.strip != "KOT_Time"           
      )    
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end
  
end
