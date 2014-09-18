class CreateCompBillDetailBackups < ActiveRecord::Migration
  def change
    test = Rails.env.development? ? "ENGINE=MyISAM" : ""
    create_table :comp_bill_detail_backups, options: test do |t| 
      t.references       :comp_bill_master_backup       # find comp bill master backup      
      t.integer          :auto_no
      t.integer          :serial_no
      t.references       :item                          # find item
      t.float            :rate
      t.integer          :qty
      t.float            :amount 
      t.boolean          :quety
      t.string           :canceled
      t.string           :excisable
      t.float            :excise_amount
      t.float            :mrp
      t.string           :combo_parent
      t.datetime         :kot_time
      t.string           :step,                 default: 'started'
      t.timestamps
    end
    add_index :comp_bill_detail_backups, [:comp_bill_master_backup_id, :auto_no], unique: true
    add_index :comp_bill_detail_backups, :item_id
  end
end