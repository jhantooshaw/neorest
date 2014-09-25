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
        $line = line
        remark = location.remark_masters.where(remarks: sheet.cell(line, 'B')).first_or_initialize                
        remark.save!       
      end
    rescue Exception => e
      success = false
      msg = e.message + " in remarks master at line no #{$line}"
    end
    return success, msg
  end  
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #["AutoId", "Remarks"]
    begin
      raise "Please set proper header for RemarksMaster sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "AutoId" || 
          sheet.cell(1, 'B').to_s.strip != "Remarks")         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
end
