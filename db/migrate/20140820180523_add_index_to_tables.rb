class AddIndexToTables < ActiveRecord::Migration
  def change
#    add_column :tables, :outlet_id, :integer 
#    add_index :bill_master_backups, [:location_id, :outlet_id, :bill_no, :bill_date, :bill_type, :financial_year_id], name: 'by_location_outlet_bill', unique: true
#    add_index :bill_master_backups, :financial_year_id
#    add_index :bill_master_backups, :outlet_id
#    add_index :bill_master_backups, :bill_no    
#    add_index :bill_master_backups, :bill_date    
#    add_index :bill_master_backups, :pay_type
#    add_index :bill_master_backups, :customer_id
#    add_index :bill_master_backups, :customer_name
#    add_index :bill_master_backups, :canceled
#    
#    add_index :bill_detail_backups, [:bill_master_backup_id, :auto_no], unique: true
#    add_index :bill_detail_backups, :item_id
#     
#    add_index :bill_settlements, [:bill_master_backup_id, :auto_no], unique: true
#    add_index :bill_settlements, :pay_type
#    add_index :bill_settlements, :customer_id
#    add_index :bill_settlements, :customer_name
#    add_index :bill_settlements, :manager_bit
#    add_index :bill_settlements, :cc_name
  end
end
