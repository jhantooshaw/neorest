class CreateAdjBillSettlements < ActiveRecord::Migration
  def change
    create_table :adj_bill_settlements do |t|
      t.references       :adj_bill_master_backup      # find adj bill master backup      
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
    add_index :adj_bill_settlements, [:adj_bill_master_backup_id, :auto_no], unique: true
    add_index :adj_bill_settlements, :pay_type
    add_index :adj_bill_settlements, :customer_id
    add_index :adj_bill_settlements, :customer_name
    add_index :adj_bill_settlements, :manager_bit
  end
end