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
  
  def self.checked_attributes(sheet)
    success =  true
    msg = ""
    #["CoName", "LocationName", "Outlet", "KOT_Print", "Settlement_Print", "Cut_File", "Waiter", "Steward", "BillNoCont", "KOTNoAuto", "BillPrintDos", "BillWidth",
    # "BottomMargin", "BillCopies", "RemarksItem", "Cancel_KOT_Print", "PAX", "BarFoodBillNoSep", "KOTCopies", "RateToPrintInBill", "Local_KOT_Print", "Single_Lan_KOT_Print", 
    # "Cash_Drawer_File", "Multiple_Outlet", "HotelLink", "BillPage", "KOTPrint", "UserPrint", "SaveKOTSamePage", "DSN", "LocalComp", "RemoteComp", "KOTPrintGroupBlank", 
    # "WaiterFixed", "MenuOutletWise", "FirstQtyThenCode", "WaiterCommonForOutlet", "UserCommonForOutlet", "WarningMsgDate", "DeliverySettlementPage", "MulipleLocation", 
    # "AutoEmail", "SenderEmail", "ReceiverEmail", "SaveBillInText", "FilePath", "ComboOfferReverse", "LogoPrint", "TimePrint", "BillNoSepearteOfOutlets", "SettlementTogether", 
    # "UpdateInv", "BarAlais", "FoodAlias", "TouchScreen", "CoNamePrn", "AddPrintKOT", "EstablishmentCharge", "EstablishmentOn", "EstablishmentPer", "StubPrint", "AmtInCompBill", 
    # "UserPrintKOT", "TimePrintKOT", "SaveTime", "MRPnEstShowInBarBill", "PPforPC", "POPforMIC", "InSaToDeductTax2Inc", "WinBillLine2", "CardSwipe", "CoNo", "LocationNo", 
    # "BillWinPrintType", "MrpBillType", "PortName"]

    begin
      raise "Please set proper header for cust_detail sheet in excel file" if sheet.last_row > 1 && (sheet.cell(1, 'A').to_s.strip != "CoName" || 
          sheet.cell(1, 'B').to_s.strip != "LocationName" || 
          sheet.cell(1, 'C').to_s.strip != "Outlet" || sheet.cell(1, 'D').to_s.strip != "KOT_Print" || sheet.cell(1, 'E').to_s.strip != "Settlement_Print" || 
          sheet.cell(1, 'F').to_s.strip != "Cut_File"  || sheet.cell(1, 'G').to_s.strip != "Waiter"   || sheet.cell(1, 'H').to_s.strip != "Steward" ||
          sheet.cell(1, 'I').to_s.strip != "BillNoCont"  || sheet.cell(1, 'J').to_s.strip != "KOTNoAuto"   || sheet.cell(1, 'K').to_s.strip != "BillPrintDos" ||
          sheet.cell(1, 'L').to_s.strip != "BillWidth"   || sheet.cell(1, 'M').to_s.strip != "BottomMargin" || 
          sheet.cell(1, 'N').to_s.strip != "BillCopies"  || sheet.cell(1, 'O').to_s.strip != "RemarksItem"   || sheet.cell(1, 'P').to_s.strip != "Cancel_KOT_Print" ||
          sheet.cell(1, 'Q').to_s.strip != "PAX"   || sheet.cell(1, 'R').to_s.strip != "BarFoodBillNoSep" ||
          sheet.cell(1, 'S').to_s.strip != "KOTCopies"   || sheet.cell(1, 'T').to_s.strip != "RateToPrintInBill"||          
          sheet.cell(1, 'U').to_s.strip != "Local_KOT_Print"   || sheet.cell(1, 'V').to_s.strip != "Single_Lan_KOT_Print" ||
          sheet.cell(1, 'W').to_s.strip != "Cash_Drawer_File"   || sheet.cell(1, 'X').to_s.strip != "Multiple_Outlet" ||
          sheet.cell(1, 'Y').to_s.strip != "HotelLink"   || sheet.cell(1, 'Z').to_s.strip != "BillPage" ||
          sheet.cell(1, 'AA').to_s.strip != "KOTPrint"   || sheet.cell(1, 'AB').to_s.strip != "UserPrint" ||         
          sheet.cell(1, 'AC').to_s.strip != "SaveKOTSamePage" || sheet.cell(1, 'AD').to_s.strip != "DSN" || sheet.cell(1, 'AE').to_s.strip != "LocalComp" || 
          sheet.cell(1, 'AF').to_s.strip != "RemoteComp"  || sheet.cell(1, 'AG').to_s.strip != "KOTPrintGroupBlank"   || sheet.cell(1, 'AH').to_s.strip != "WaiterFixed" ||
          sheet.cell(1, 'AI').to_s.strip != "MenuOutletWise"  || sheet.cell(1, 'AJ').to_s.strip != "FirstQtyThenCode"   || sheet.cell(1, 'AK').to_s.strip != "WaiterCommonForOutlet" ||
          sheet.cell(1, 'AL').to_s.strip != "UserCommonForOutlet"   || sheet.cell(1, 'AM').to_s.strip != "WarningMsgDate" || 
          sheet.cell(1, 'AN').to_s.strip != "DeliverySettlementPage"  || sheet.cell(1, 'AO').to_s.strip != "MulipleLocation"   || sheet.cell(1, 'AP').to_s.strip != "AutoEmail" ||
          sheet.cell(1, 'AQ').to_s.strip != "SenderEmail"   || sheet.cell(1, 'AR').to_s.strip != "ReceiverEmail" ||
          sheet.cell(1, 'AS').to_s.strip != "SaveBillInText"   || sheet.cell(1, 'AT').to_s.strip != "FilePath"||          
          sheet.cell(1, 'AU').to_s.strip != "ComboOfferReverse"   || sheet.cell(1, 'AV').to_s.strip != "LogoPrint" ||
          sheet.cell(1, 'AW').to_s.strip != "TimePrint"   || sheet.cell(1, 'AX').to_s.strip != "BillNoSepearteOfOutlets"||
          sheet.cell(1, 'AY').to_s.strip != "SettlementTogether"   || sheet.cell(1, 'AZ').to_s.strip != "UpdateInv" ||          
          sheet.cell(1, 'BA').to_s.strip != "BarAlais"   || sheet.cell(1, 'BB').to_s.strip != "FoodAlias" ||          
          sheet.cell(1, 'BC').to_s.strip != "TouchScreen" || sheet.cell(1, 'BD').to_s.strip != "CoNamePrn" || sheet.cell(1, 'BE').to_s.strip != "AddPrintKOT" || 
          sheet.cell(1, 'BF').to_s.strip != "EstablishmentCharge"  || sheet.cell(1, 'BG').to_s.strip != "EstablishmentOn"   || sheet.cell(1, 'BH').to_s.strip != "EstablishmentPer" ||
          sheet.cell(1, 'BI').to_s.strip != "StubPrint"  || sheet.cell(1, 'BJ').to_s.strip != "AmtInCompBill"   || sheet.cell(1, 'BK').to_s.strip != "UserPrintKOT" ||
          sheet.cell(1, 'BL').to_s.strip != "TimePrintKOT"   || sheet.cell(1, 'BM').to_s.strip != "SaveTime" || 
          sheet.cell(1, 'BN').to_s.strip != "MRPnEstShowInBarBill"  || sheet.cell(1, 'BO').to_s.strip != "PPforPC"   || sheet.cell(1, 'BP').to_s.strip != "POPforMIC" ||
          sheet.cell(1, 'BQ').to_s.strip != "InSaToDeductTax2Inc"   || sheet.cell(1, 'BR').to_s.strip != "WinBillLine2" ||
          sheet.cell(1, 'BS').to_s.strip != "CardSwipe" || sheet.cell(1, 'BT').to_s.strip != "CoNo"||          
          sheet.cell(1, 'BU').to_s.strip != "LocationNo" || sheet.cell(1, 'BV').to_s.strip != "BillWinPrintType" ||
          sheet.cell(1, 'BW').to_s.strip != "MrpBillType" || sheet.cell(1, 'BX').to_s.strip != "PortName"
      )         
    rescue Exception => e
      success = false
      msg = e.message
    end      
    return success, msg
  end 
  
end