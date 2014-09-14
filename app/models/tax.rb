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
          tax5_per:               sheet.cell(line, 'W').to_f
        }        
        tax = location.taxes.where(tax_auto_id: sheet.cell(line, 'A').to_i).first_or_initialize                
        tax.update_attributes!(params)        
      end
    rescue Exception => e
      success = false
      msg = e.message + " in tax"
    end
    return success, msg
  end    
end