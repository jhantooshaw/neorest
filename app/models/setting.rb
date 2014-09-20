class Setting < ActiveRecord::Base
  belongs_to   :location
  belongs_to   :outlet
  
  validates    :location_id, presence: true
  validates_uniqueness_of :location_id,        scope: :outlet_id, case_sensitive: false, message: "duplicate entry" 
  
  def self.import(sheet, location)
    success =  true
    msg = ""
    begin
      p "Setting Sheet Row: #{sheet.last_row}"
      2.upto(sheet.last_row) do |line|
        $line = line
        outlet_name    = sheet.cell(line, 'C')       
        outlet = location.outlets.where(name: outlet_name).first
        raise "Outlet #{outlet_name} is not found" if outlet.blank?         
        params = {
          outlet_id:                 outlet.present? ? outlet.id : "",  
          co_name:                   sheet.cell(line, 'A'),
          kot_print:                 sheet.cell(line, 'D').gsub("'", "").to_i,                    
          settlement_print:          sheet.cell(line, 'E').gsub("'", "").to_i,
          cut_file:                  sheet.cell(line, 'F'),        
          by_waiter:                 sheet.cell(line, 'G').gsub("'", "").to_i,        
          by_steward:                sheet.cell(line, 'H').gsub("'", "").to_i,        
          bill_no_cont:              sheet.cell(line, 'I').gsub("'", "").to_i,        
          kot_no_auto:               sheet.cell(line, 'J').gsub("'", "").to_i,        
          bill_print_dos:            sheet.cell(line, 'K').gsub("'", "").to_i,        
          bill_width:                sheet.cell(line, 'L').gsub("'", "").to_i,        
          bottom_margin:             sheet.cell(line, 'M').gsub("'", "").to_i,        
          bill_copies:               sheet.cell(line, 'N').gsub("'", "").to_i,        
          remarks_item:              sheet.cell(line, 'O'),        
          cancel_kot_print:          sheet.cell(line, 'P').gsub("'", "").to_i,        
          pax:                       sheet.cell(line, 'Q').gsub("'", "").to_i,        
          bar_food_bill_no_sep:      sheet.cell(line, 'R').gsub("'", "").to_i,        
          kot_copies:                sheet.cell(line, 'S').gsub("'", "").to_i,        
          rate_print_in_bill:        sheet.cell(line, 'T'),        
          local_kot_print:           sheet.cell(line, 'U').gsub("'", "").to_i,        
          single_lane_kot_print:     sheet.cell(line, 'V').gsub("'", "").to_i,        
          cash_drawer_file:          sheet.cell(line, 'W'),        
          multiple_outlet:           sheet.cell(line, 'X'),        
          hotel_link:                sheet.cell(line, 'Y'),        
          bill_page:                 sheet.cell(line, 'Z'),            
          kotprint:                  sheet.cell(line, 'AA'),        
          user_print:                sheet.cell(line, 'AB'),        
          save_kot_same_page:        sheet.cell(line, 'AC'),        
          dsn:                       sheet.cell(line, 'AD') == 'false' ? false : true,         
          local_comp:                sheet.cell(line, 'AE'),        
          remote_comp:               sheet.cell(line, 'AF'),        
          kot_print_group_blank:     sheet.cell(line, 'AG').gsub("'", "").to_i,        
          waiter_fixed:              sheet.cell(line, 'AH').gsub("'", "").to_i,        
          first_qty_then_code:       sheet.cell(line, 'AI').gsub("'", "").to_i,        
          menu_outlet_wise:          sheet.cell(line, 'AJ'),    
          waiter_common_for_outlet:  sheet.cell(line, 'AK').gsub("'", "").to_i, 
          user_common_for_outlet:    sheet.cell(line, 'AL').gsub("'", "").to_i,
          warning_msg_date:          sheet.cell(line, 'AM').gsub("'", "").to_i,                    
          delivery_settlement_page:  sheet.cell(line, 'AN').gsub("'", "").to_i,        
          multiple_location:         sheet.cell(line, 'AO'),        
          auto_email:                sheet.cell(line, 'AP') == 'false' ? false : true,
          sender_email:              sheet.cell(line, 'AQ'),        
          receiver_email:            sheet.cell(line, 'AR'),        
          save_bill_in_text:         sheet.cell(line, 'AS') == 'false' ? false : true,        
          file_path:                 sheet.cell(line, 'AT'),        
          combo_offer_for_reverse:   sheet.cell(line, 'AU') == 'false' ? false : true,          
          logo_print:                sheet.cell(line, 'AV'),        
          time_print:                sheet.cell(line, 'AW'),        
          bill_no_separate_outlet:   sheet.cell(line, 'AX') == 'true' ? true : false,        
          settlement_together:       sheet.cell(line, 'AY') == 'false' ? false : true,        
          update_inv:                sheet.cell(line, 'AZ') == 'false' ? false : true,          
          bar_alias:                 sheet.cell(line, 'BA'),     
          food_alias:                sheet.cell(line, 'BB'), 
          touch_screen:              sheet.cell(line, 'BC') == 'false' ? false : true,        
          co_name_print:             sheet.cell(line, 'BD') == 'true' ? true : false,       
          add_print_kot:             sheet.cell(line, 'BE') == 'false' ? false : true,        
          establishment_charge:      sheet.cell(line, 'BF') == 'false' ? false : true,        
          establishment_on:          sheet.cell(line, 'BG'),        
          establishment_perc:        sheet.cell(line, 'BH').to_i,               
          stub_print:                sheet.cell(line, 'BI') == 'false' ? false : true,     
          amount_in_comp_bill:       sheet.cell(line, 'BJ') == 'false' ? false : true,     
          user_print_kot:            sheet.cell(line, 'BK') == 'true' ? true : false,     
          time_print_kot:            sheet.cell(line, 'BL') == 'true' ? true : false,     
          save_time:                 sheet.cell(line, 'BM') == 'true' ? true : false,
          mrp_and_est_show_inbarbill:sheet.cell(line, 'BN') == 'false' ? false : true,     
          pp_for_pc:                 sheet.cell(line, 'BO').to_i,     
          pop_for_mic:               sheet.cell(line, 'BP').to_i,     
          insa_to_deduct_tax2_inc:   sheet.cell(line, 'BQ') == 'false' ? false : true,     
          win_bill_line2:            sheet.cell(line, 'BR') == 'false' ? false : true,     
          card_swip:                 sheet.cell(line, 'BS') == 'false' ? false : true,     
          co_no:                     sheet.cell(line, 'BT'),     
          location_no:               sheet.cell(line, 'BU'),     
          bill_win_print_type:       sheet.cell(line, 'BV'),
          mrp_bill_type:             sheet.cell(line, 'BW').gsub("'", "").to_i,
          port_no:                   sheet.cell(line, 'BX')
        }        
        setting= location.settings.where(outlet_id: outlet.id).first_or_initialize                
        setting.update_attributes!(params)   
        
        
      end
    rescue Exception => e
      success = false
      msg = e.message + " in setting at line no #{$line}"
    end
    return success, msg
  end   
end