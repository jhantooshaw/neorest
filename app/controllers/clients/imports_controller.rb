#require 'roo'
#require 'spreadsheet'
class Clients::ImportsController < ApplicationController
  before_action :authenticate_client!, :retrieve_data  
  layout "client"
  
  #Import master tables data
  def import_master
    begin
      if request.post?
        raise "Please attach an excel file for import master tables" if params[:import_file].blank?  
        status = ""
        set_original_path(params[:import_file])     
        data = Roo::Spreadsheet.open(@original_path)        
        begin
          data.default_sheet = "Outlet_Master"
          status = Outlet.import(data, current_location)
        rescue Exception => e          
        end          
        raise status[1] if status [0] == false
        begin
          data.default_sheet = "ComboPackage"
          status = ComboPackage.import(data, current_location)
        rescue Exception => e          
        end 
        raise status[1] if status [0] == false 
        begin
          data.default_sheet = "Table_Section"
          status = TableSection.import(data, current_location)
        rescue Exception => e          
        end 
        raise status[1] if status [0] == false        
        begin
          data.default_sheet = "User_Master"
          status = Staff.import(data, current_location)
        rescue Exception => e          
        end 
        raise status[1] if status [0] == false
        
        data.each_with_pagename do |name, sheet|
          table_name = name.downcase
          case table_name
          when "bill_footer_setting"
            status = FooterSetting.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false 
          when "bill_group" 
            status = BillGroup.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false 
          when "combooffer"
            status = ComboOffer.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false 
          when "creditcard_master"
            status = CreditCard.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false   
          when "cust_detail"
            status = Customer.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false 
          when "item_groups"
            status = ItemGroup.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false 
          when "item_groups_kot_print"
            status = ItemGroupsKotPrint.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false 
          when "item_sub_group" 
            status = ItemSubGroup.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false 
          when "items"
            status = Item.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false 
          when "table_master"
            status = Table.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false 
          when "settings"
            status = Setting.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false   
          when "remarksmaster"
            status = RemarkMaster.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false  
          when "table_section"
            status = TableSection.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false  
          when "tax"
            status = Tax.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false              
          when "user_validation"  
            status = StaffSubMenuSetting.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false  
          when "usermainmenu"  
            status = StaffMenuSetting.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false                        
          when "waiter"  
            status = Waiter.import(sheet, current_location) unless sheet.last_row <= 1
            raise status[1] if status [0] == false  
          end          
        end
        flash[:notice] = "Master data is imported successfully."
        redirect_to client_path
      end
    rescue Exception => e
      flash.now[:info] = e.message
      render :import_master
    end
  end
  
  
  # import transaction detail
  def transaction    
    begin
      if request.post?
        raise 'Please attach an excel file for import master tables' if params[:import_file].blank?  
        status = ""
        tables = ['Bill_Master_Backup']
        set_original_path(params[:import_file])     
        data = Roo::Spreadsheet.open(@original_path) 
        
        data.default_sheet = 'Bill_Master_Backup'
        unless data.last_row <= 1
          status = BillMasterBackup.import(data, current_location)
          raise status[1] if status [0] == false
        end 
        data.default_sheet = 'Bill_Detail_Backup'
        unless data.last_row <= 1
          status = BillDetailBackup.import(data, current_location)
          raise status[1] if status [0] == false
        end    
        data.default_sheet = 'Bill_Settlement'
        unless data.last_row <= 1
          status = BillSettlement.import(data, current_location)
          raise status[1] if status [0] == false
        end
        
        tables << 'Adj_Bill_Master_Backup'
        data.default_sheet = 'Adj_Bill_Master_Backup'
        unless data.last_row <= 1
          status = AdjBillMasterBackup.import(data, current_location)
          raise status[1] if status [0] == false
        end   
        data.default_sheet = 'Adj_Bill_Detail_Backup'
        unless data.last_row <= 1
          status = AdjBillDetailBackup.import(data, current_location)
          raise status[1] if status [0] == false
        end    
        data.default_sheet = 'Adj_Bill_Settlement'
        unless data.last_row <= 1
          status = AdjBillSettlement.import(data, current_location)
          raise status[1] if status [0] == false
        end
                
        tables << 'Comp_Bill_Master_Backup'
        data.default_sheet = 'Comp_Bill_Master_Backup'
        unless data.last_row <= 1
          status = CompBillMasterBackup.import(data, current_location)
          raise status[1] if status [0] == false
        end
        data.default_sheet = 'Comp_Bill_Detail_Backup'
        unless data.last_row <= 1
          status = CompBillDetailBackup.import(data, current_location)
          raise status[1] if status [0] == false
        end
                
        tables << 'Void_Bills'
        data.default_sheet = 'Void_Bills'
        unless data.last_row <= 1
          status = VoidBill.import(data, current_location)
          raise status[1] if status [0] == false
        end 
        
        BillMasterBackup.change_step('started', 'imported')       
        BillDetailBackup.change_step('started', 'imported')       
        BillSettlement.change_step('started', 'imported')  
        
        AdjBillMasterBackup.change_step('started', 'imported')       
        AdjBillDetailBackup.change_step('started', 'imported')       
        AdjBillSettlement.change_step('started', 'imported') 
        
        CompBillMasterBackup.change_step('started', 'imported')       
        CompBillDetailBackup.change_step('started', 'imported')       
        Void.change_step('started', 'imported') 
        
        
        flash[:notice] = "Transaction data is imported successfully."
        redirect_to client_path
      end
    rescue Exception => e
      ssssssssss
      tables.each do |table|
        case table
        when 'Bill_Master_Backup'
          BillMasterBackup.unscoped.where(step: 'started').delete_all
          BillDetailBackup.unscoped.where(step: 'started').delete_all
          BillSettlement.unscoped.where(step: 'started').delete_all
        when 'Adj_Bill_Master_Backup'
          AdjBillMasterBackup.unscoped.where(step: 'started').delete_all
          AdjBillDetailBackup.unscoped.where(step: 'started').delete_all
          AdjBillSettlement.unscoped.where(step: 'started').delete_all
        when 'Comp_Bill_Master_Backup'
          CompBillMasterBackup.unscoped.where(step: 'started').delete_all
          CompBillDetailBackup.unscoped.where(step: 'started').delete_all
        when 'Void_Bills'
          VoidBill.unscoped.where(step: 'started').destroy_all
        end
      end unless tables.blank?
      flash.now[:info] = e.message
      render :transaction
    end
    
  end
  
  private
  def set_original_path(params_file)
    file_name = params_file.original_filename
    dest = File.join(Rails.root, "tmp")
    FileUtils.mkdir_p(dest) unless File.exists?(dest)
    @original_path = File.join(dest, file_name).to_s
    File.delete(@original_path) if File.exist?(@original_path)
    File.open(@original_path, "wb") { |f| f.write(params_file.tempfile.read) }
  end
end