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
  validates_uniqueness_of :name,        scope: [:start_date, :end_date], case_sensitive: false, message: "duplicate entry" 
    
  def self.import(sheet, current_client)   
    begin
      p "Financial Year Sheet Row: #{sheet.last_row}"      
      2.upto(sheet.last_row) do |line|       
        fin_year = current_client.financial_years.where(name: sheet.cell(line, 'B'), start_date: sheet.cell(line, 'C'), end_date: sheet.cell(line, 'D')).first_or_initialize                
        fin_year.save!
      end     
    rescue Exception => e
      success = false
      msg = e.message + " in financial year."
    end      
    return success, msg
  end  
end