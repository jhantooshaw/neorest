class BillMasterBackup < ActiveRecord::Base  
  belongs_to :location
  belongs_to :financial_year
  belongs_to :outlet
  belongs_to :waiter
  belongs_to :steward
  belongs_to :tax
  belongs_to :customer
  
  has_many   :bill_detail_backups,          dependent: :destroy
  has_many   :bill_settlements,             dependent: :destroy
  
  validates  :bill_no, :bill_date, :bill_type, :location, :outlet, :financial_year, presence:  true
  validates_uniqueness_of :bill_no,        scope: [:bill_date, :bill_type, :location, :outlet, :financial_year], case_sensitive: false, message: "duplicate entry"
  
  default_scope {where(step: 'imported')}
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Bill Master Backup Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        @line = line
        outlet_name = sheet.cell(line, 'E')
        outlet      = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found into database" if outlet.blank?
        fin_year_name = sheet.cell(line, 'G')
        fin_year      = location.financial_years.where(name: fin_year_name).first
        raise "Financial Year #{fin_year_name} is not found into database" if fin_year.blank?        
        waiter_id    = sheet.cell(line, 'I').to_i unless sheet.cell(line, 'I').blank?
        steward_id   = sheet.cell(line, 'K').to_i if sheet.cell(line, 'K').present? && sheet.cell(line, 'K').to_i != 0
        customer     = location.customers.where(c_name: sheet.cell(line, 'AX')).first unless sheet.cell(line, 'AX').blank?       
        
        bill_no      = sheet.cell(line, 'A').to_i
        bill_date    = sheet.cell(line, 'C')
        bill_type    = sheet.cell(line, 'D')
        
        params = { 
          table_no:        sheet.cell(line, 'B'),
          bill_time:       sheet.cell(line, 'H'),
          dis_per:         sheet.cell(line, 'M').to_f,
          discount:        sheet.cell(line, 'N').to_f,
          service_tax_per: sheet.cell(line, 'O').to_i,
          service_tax:     sheet.cell(line, 'P').to_f,
          edu_tax_per:     sheet.cell(line, 'Q').to_f,
          edu_tax:         sheet.cell(line, 'R').to_f,
          hs_edu_tax_per:  sheet.cell(line, 'S').to_f,
          hs_edu_tax:      sheet.cell(line, 'T').to_f,
          tax1:            sheet.cell(line, 'U'),
          tax1_per:        sheet.cell(line, 'V').to_f,
          tax1_amount:     sheet.cell(line, 'W').to_f,
          tax2:            sheet.cell(line, 'X'),
          tax2_per:        sheet.cell(line, 'Y').to_f,
          tax2_amount:     sheet.cell(line, 'Z').to_f,
          tax3:            sheet.cell(line, 'AA'),
          tax3_per:        sheet.cell(line, 'AB').to_f,
          tax3_amount:     sheet.cell(line, 'AC').to_f,
          tax4:            sheet.cell(line, 'AD'),
          tax4_per:        sheet.cell(line, 'AE').to_f,
          tax4_amount:     sheet.cell(line, 'AF').to_f,
          s_tax:           sheet.cell(line, 'AG').to_f,
          excise_amount:   sheet.cell(line, 'AH').to_f,
          round_off:       sheet.cell(line, 'AI').to_f,
          net_amount:      sheet.cell(line, 'AJ').to_f,
          total_amount:    sheet.cell(line, 'AK').to_f,
          sub_total_amount:   sheet.cell(line, 'AL').to_f,
          taxable_amount:     sheet.cell(line, 'AM').to_f,
          non_taxable_amount: sheet.cell(line, 'AN').to_f,
          exciseable_amount:  sheet.cell(line, 'AO').to_f,
          pay_type:        sheet.cell(line, 'AP'),
          user_id:         0,
          user_name:       sheet.cell(line, 'AQ'),         
          modified_by:     0, # sheet.cell(line, 'AR'),
          modified_name:   sheet.cell(line, 'AR'),
          modified_date:   sheet.cell(line, 'AS').present? ? Date.strptime(sheet.cell(line, 'AS'), '%m/%d/%Y') : nil,
          modified_time:   sheet.cell(line, 'AT'),
          canceled:        sheet.cell(line, 'AU'),
          cover:           sheet.cell(line, 'AV').to_i,
          comment:         sheet.cell(line, 'AW'),
          customer_id:     customer.present?   ? customer.id : nil, 
          customer_name:   sheet.cell(line, 'AX'),       
          delivery:        sheet.cell(line, 'AY'),
          cc_name:         sheet.cell(line, 'AZ'),
          actual_amount:   sheet.cell(line, 'BA').to_f,
          food_amount:     sheet.cell(line, 'BB').to_f,
          food_tax:        sheet.cell(line, 'BC').to_f,
          food_total:      sheet.cell(line, 'BD').to_f,
          beverage_amount: sheet.cell(line, 'BE').to_f,
          beverage_tax:    sheet.cell(line, 'BF').to_f,
          beverage_total:  sheet.cell(line, 'BG').to_f,
          wine_amount:     sheet.cell(line, 'BH').to_f,
          beer_amount:     sheet.cell(line, 'BI').to_f,
          cal_sub_total:   sheet.cell(line, 'BJ').to_f,
          tips:            sheet.cell(line, 'BK').to_f,
          grand_total:     sheet.cell(line, 'BL').to_f,
          settle_time:     sheet.cell(line, 'BM'),
          no_of_print:     sheet.cell(line, 'BN').to_i,
          pay_changed:     sheet.cell(line, 'BO'),
          dis_food:        sheet.cell(line, 'BP').to_f,
          dis_liquer:      sheet.cell(line, 'BQ').to_f,
          dis_both:        sheet.cell(line, 'BR').to_f,
          room_no:         sheet.cell(line, 'BS'),
          hotel_date:      sheet.cell(line, 'BT'),
          banquet:         sheet.cell(line, 'BU'),
          out_time:        sheet.cell(line, 'BV'),          
          rate_incd_of_tax1:      sheet.cell(line, 'BW') == 'false' ? false : true, 
          tax_cal_after_dis:      sheet.cell(line, 'BX'),
          rate_incd_of_stax:      sheet.cell(line, 'BY') == 'false' ? false : true, 
          service_tax_applicable: sheet.cell(line, 'BZ') == 'false' ? false : true, 
          abatement:       sheet.cell(line, 'CA').to_f,
          tax1_cal_last:          sheet.cell(line, 'CB') == 'false' ? false : true, 
          linked_financial_year:  sheet.cell(line, 'CC'),          
          tax5:            sheet.cell(line, 'CD'),
          tax5_per:        sheet.cell(line, 'CE').to_f,
          tax5_amount:     sheet.cell(line, 'CF').to_f,          
          stontax4:               sheet.cell(line, 'CG') == 'false' ? false : true,
          stontax4_per:    sheet.cell(line, 'CH').to_f,
          stontax4_amount: sheet.cell(line, 'CI').to_f,
          waiter_id:       waiter_id.present?  ? waiter_id  : nil,        
          steward_id:      steward_id.present? ? steward_id : nil        
        }
        
        bill_master_backup = BillMasterBackup.unscoped.where(location_id: location.id, outlet_id: outlet.id, financial_year_id: fin_year.id, bill_no: bill_no,
          bill_date: bill_date, bill_type: bill_type).first_or_initialize                
        bill_master_backup.update_attributes!(params)  if bill_master_backup.new_record? 
      end
    rescue Exception => e
      success = false
      msg = e.message + " in bill master backup at line no #{@line}"
    end      
    return success, msg
  end
  
  def self.change_step(from, to)
    unscoped.where(step: from).update_all(step: to)
  end  
end