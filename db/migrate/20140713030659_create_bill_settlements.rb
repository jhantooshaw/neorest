class CreateBillSettlements < ActiveRecord::Migration
  def change
    create_table :bill_settlements do |t|
      t.references       :bill_master_backup      # find bill master backup      
      t.integer          :auto_no
      t.string           :pay_type
      t.float            :pay_amount
      t.string           :cc_name
      t.string           :cashier
      t.references       :customer            # find customer 
      t.string           :customer_name
      t.string           :table_no
      t.text             :comment
      t.float            :tips
      t.string           :room_no
      t.datetime         :hotel_date
      t.string           :manager_bit
      t.datetime         :manager_date
      t.string           :step,                 default: 'started'      
      t.timestamps
    end
    add_index :bill_settlements, [:bill_master_backup_id, :auto_no], unique: true
    add_index :bill_settlements, :pay_type
    add_index :bill_settlements, :customer_id
    add_index :bill_settlements, :customer_name
    add_index :bill_settlements, :manager_bit
    add_index :bill_settlements, :cc_name
  end
end