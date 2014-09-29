class Customer < ActiveRecord::Base
  belongs_to    :location  
  has_many      :bill_master_backups
  has_many      :adj_bill_master_backups
  has_many      :bill_settlements
  has_many      :comp_bill_master_backups
  has_many      :void_bills
  
  validates  :location, :membership_no, :presence => true
  validates_uniqueness_of :membership_no,  scope: [:location_id], case_sensitive: false, message: "duplicate entry" 
  
  
  def full_address
     [address1, address2, zipcode].compact.join(', ')
  end
  
  def phones
     [phone1, phone2, mobile].compact.join(', ')
  end
    
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Customer Sheet Row: #{sheet.last_row}"      
      2.upto(sheet.last_row) do |line|     
        $line = line
        params = {
          c_name:      sheet.cell(line, 'B'), 
          address1:    sheet.cell(line, 'C'), 
          address2:    sheet.cell(line, 'D') == "BLANK"  ? "" : sheet.cell(line, 'D'), 
          zipcode:     sheet.cell(line, 'E').to_i == 0   ? "" : sheet.cell(line, 'E').to_i.to_s, 
          phone1:      sheet.cell(line, 'F').to_i == 0   ? "" : sheet.cell(line, 'F').to_i.to_s, 
          phone2:      sheet.cell(line, 'G').to_i == 0   ? "" : sheet.cell(line, 'G').to_i.to_s, 
          mobile:      sheet.cell(line, 'H').to_i == 0   ? "" : sheet.cell(line, 'H').to_i.to_s, 
          fax:         sheet.cell(line, 'I').to_i == 0   ? "" : sheet.cell(line, 'I').to_i.to_s, 
          dob:         sheet.cell(line, 'J'), 
          ann:         sheet.cell(line, 'K'),           
          entry_date:  sheet.cell(line, 'L'),          
          email:       sheet.cell(line, 'M') == "BLANK"  ? "" : sheet.cell(line, 'M'), 
          dis_per:     sheet.cell(line, 'N').to_f, 
          order_date:  sheet.cell(line, 'Q'), 
          remarks:     sheet.cell(line, 'R'),           
          membership_no_manual: sheet.cell(line, 'S'),
          card_no:     sheet.cell(line, 'T')          
        }        
        customer = location.customers.where(membership_no: sheet.cell(line, 'A').to_i).first_or_initialize                
        customer.update_attributes!(params)
      end
    rescue Exception => e
      success = false
      msg = e.message + " in customer at line no #{$line}"
    end      
    return success, msg
  end   
  
  

  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #["Membership_No", "Cust_Name", "Add1", "Add2", "Pin", "Ph1", "Ph2", "Mob", "Fax", "DOB", "Ann", "EntryDate", "Email", "DisPer", "Outlet", "LocationName",
    #"OrderDate", "Remarks", "Membership_No_Manual", "CardNo"]

    begin
      raise "Please set proper header for cust_detail sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Membership_No" || 
          sheet.cell(1, 'B').to_s.strip != "Cust_Name" || 
          sheet.cell(1, 'C').to_s.strip != "Add1" || sheet.cell(1, 'D').to_s.strip != "Add2" || sheet.cell(1, 'E').to_s.strip != "Pin" || 
          sheet.cell(1, 'F').to_s.strip != "Ph1"  || sheet.cell(1, 'G').to_s.strip != "Ph2"   || sheet.cell(1, 'H').to_s.strip != "Mob" ||
          sheet.cell(1, 'I').to_s.strip != "Fax"  || sheet.cell(1, 'J').to_s.strip != "DOB"   || sheet.cell(1, 'K').to_s.strip != "Ann" ||
          sheet.cell(1, 'L').to_s.strip != "EntryDate"   || sheet.cell(1, 'M').to_s.strip != "Email" || 
          sheet.cell(1, 'N').to_s.strip != "DisPer"  || sheet.cell(1, 'O').to_s.strip != "Outlet"   || sheet.cell(1, 'P').to_s.strip != "LocationName" ||
          sheet.cell(1, 'Q').to_s.strip != "OrderDate"   || sheet.cell(1, 'R').to_s.strip != "Remarks" ||
          sheet.cell(1, 'S').to_s.strip != "Membership_No_Manual"   || sheet.cell(1, 'T').to_s.strip != "CardNo"
      )         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
  
  
end