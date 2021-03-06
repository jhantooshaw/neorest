class FinancialYear < ActiveRecord::Base  
  #attr_accessible :name, :start_date, :end_date,  :client_id
  belongs_to    :client
  has_many      :financial_years_locations
  has_many      :locations, through: :financial_years_locations
  has_many      :bill_master_backups
  has_many      :adj_bill_master_backups
  has_many      :comp_bill_master_backups
  has_many      :void_bills
  
  validates     :name, :presence => true
  validates_uniqueness_of :name,        scope: [:client, :start_date, :end_date], case_sensitive: false, message: "duplicate entry" 
    
  def self.import(sheet, current_client)   
    begin
      $line = 1
      p "Financial Year Sheet Row: #{sheet.last_row}"  
      raise "Please set proper header for Financial_Year sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "Financial_Year_ID" || 
          sheet.cell(1, 'B').to_s.strip != "Financial_Year_Name" || sheet.cell(1, 'C').to_s.strip != "Start_Date" || sheet.cell(1, 'D').to_s.strip != "End_Date" 
      ) 
      2.upto(sheet.last_row) do |line| 
        $line = line
        fin_year = current_client.financial_years.where(name: sheet.cell(line, 'B'), start_date: sheet.cell(line, 'C'), end_date: sheet.cell(line, 'D')).first_or_initialize                
        fin_year.save!
      end     
    rescue Exception => e
      success = false
      msg = e.message + " in financial year at line no #{$line}"
    end      
    return success, msg
  end  
end