class RemarkMaster < ActiveRecord::Base  
  # attr_accessible :location, :remarks  
  belongs_to :client  
  belongs_to :location  
  
  validates     :location, :remarks,       presence: true
  validates_uniqueness_of :remarks,        scope: [:location], case_sensitive: false, message: "duplicate entry"
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Remarks Master Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|              
        remark = location.remark_masters.where(remarks: sheet.cell(line, 'B')).first_or_initialize                
        remark.save!       
      end
    rescue Exception => e
      success = false
      msg = e.message + " in remarks master"
    end
    return success, msg
  end  
end
