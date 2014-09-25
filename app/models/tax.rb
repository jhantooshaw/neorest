class Tax < ActiveRecord::Base
  belongs_to    :location
  belongs_to    :outlet
  has_many      :bill_master_backups
  has_many      :adj_bill_master_backups
  has_many      :comp_bill_master_backups
  
  validates     :location, :tax_auto_id, presence: true
  validates_uniqueness_of  :tax_auto_id,        scope: [:location], case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Tax Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        outlet = location.outlets.where(name: sheet.cell(line, 'Q')).first  unless sheet.cell(line, 'Q').blank?        
        params = { 
          outlet_id:              outlet.present? ? outlet.id : "",
          tax1_name:              sheet.cell(line, 'B'),
          tax1_per:               sheet.cell(line, 'C').to_f,
          tax2_name:              sheet.cell(line, 'D'),
          tax2_per:               sheet.cell(line, 'E').to_f,
          tax3_name:              sheet.cell(line, 'F'),
          tax3_per:               sheet.cell(line, 'G').to_f,
          tax4_name:              sheet.cell(line, 'H'),
          tax4_per:               sheet.cell(line, 'I').to_f,                
          tax_cal_after_dis:      sheet.cell(line, 'J'),
          rate_incd_of_stax:      sheet.cell(line, 'K'),
          service_tax_applicable: sheet.cell(line, 'L') == 'false' ? false : true,
          service_tax:            sheet.cell(line, 'M').to_f,
          edu_tax:                sheet.cell(line, 'N').to_f,
          hs_edu_tax:             sheet.cell(line, 'O').to_f,
          abatement:              sheet.cell(line, 'P').to_f,
          rate_incd_of_tax1:      sheet.cell(line, 'R') == 'false' ? false : true,
          show_tax1_incl_in_bill: sheet.cell(line, 'S') == 'false' ? false : true,
          tax1_cal_last:          sheet.cell(line, 'T') == 'false' ? false : true,
          tax5_name:              sheet.cell(line, 'V'),
          tax5_per:               sheet.cell(line, 'W').to_f,
          st_on_tax4_applicable:  sheet.cell(line, 'X') == 'false' ? false : (sheet.cell(line, 'X') == 'true' ? true : nil),
          st_per_on_tax4:         sheet.cell(line, 'Y').to_f
        }        
        tax = location.taxes.where(tax_auto_id: sheet.cell(line, 'A').to_i).first_or_initialize                
        tax.update_attributes!(params)        
      end
    rescue Exception => e
      success = false
      msg = e.message + " in tax at line no #{$line}"
    end
    return success, msg
  end  

  

  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #["AutoID", "Tax_Name1", "Tax_Per1", "Tax_Name2", "Tax_Per2", "Tax_Name3", "Tax_Per3", "Tax_Name4", "Tax_Per4", "TacCalAfterDis", "RateIncOfSTax", "ServiceTaxApplicable", 
    #"ServiceTax", "EducationCess", "SecondaryHigherEducationCess", "Abatement", "Outlet", "RateIncOfTax1", "ShowTax1IncInBill", "Tax1CalLast", "LocationName", "Tax_Name5", 
    #"Tax_Per5", "StOnTax4Applicable", "StPerOnTax4"]

    begin
      raise "Please set proper header for tax sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "AutoID" || 
          sheet.cell(1, 'B').to_s.strip != "Tax_Name1" || 
          sheet.cell(1, 'C').to_s.strip != "Tax_Per1" || sheet.cell(1, 'D').to_s.strip != "Tax_Name2" || sheet.cell(1, 'E').to_s.strip != "Tax_Per2" || 
          sheet.cell(1, 'F').to_s.strip != "Tax_Name3"  || sheet.cell(1, 'G').to_s.strip != "Tax_Per3"   || sheet.cell(1, 'H').to_s.strip != "Tax_Name4" ||
          sheet.cell(1, 'I').to_s.strip != "Tax_Per4"  || sheet.cell(1, 'J').to_s.strip != "TacCalAfterDis"   || sheet.cell(1, 'K').to_s.strip != "RateIncOfSTax" ||
          sheet.cell(1, 'L').to_s.strip != "ServiceTaxApplicable"   || sheet.cell(1, 'M').to_s.strip != "ServiceTax" || 
          sheet.cell(1, 'N').to_s.strip != "EducationCess"  || sheet.cell(1, 'O').to_s.strip != "SecondaryHigherEducationCess"   || sheet.cell(1, 'P').to_s.strip != "Abatement" ||
          sheet.cell(1, 'Q').to_s.strip != "Outlet"   || sheet.cell(1, 'R').to_s.strip != "RateIncOfTax1" ||
          sheet.cell(1, 'S').to_s.strip != "ShowTax1IncInBill"   || sheet.cell(1, 'T').to_s.strip != "Tax1CalLast" ||          
          sheet.cell(1, 'U').to_s.strip != "LocationName"   || sheet.cell(1, 'V').to_s.strip != "Tax_Name5" ||
          sheet.cell(1, 'W').to_s.strip != "Tax_Per5"   || sheet.cell(1, 'X').to_s.strip != "StOnTax4Applicable" ||
          sheet.cell(1, 'Y').to_s.strip != "StPerOnTax4" 
      )         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
  
end