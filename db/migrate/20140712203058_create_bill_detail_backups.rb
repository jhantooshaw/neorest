class CreateBillDetailBackups < ActiveRecord::Migration
  def change
    test = Rails.env.development? ? "ENGINE=MyISAM" : ""
    create_table :bill_detail_backups, options: test do |t|
      t.references        :bill_master_backup      # find bill master      
      t.integer           :auto_no
      t.integer           :serial_no
      t.references        :item                    # find item
      t.float             :rate
      t.integer           :qty
      t.float             :amount
      t.float             :excise_amount
      t.string            :taxable
      t.string            :excisable
      t.string            :discountable
      t.boolean           :quety
      t.float             :tax
      t.float             :total
      t.string            :canceled
      t.string            :under
      t.integer           :add_qty
      t.string            :kot
      t.string            :kot_time
      t.float             :mrp
      t.float             :s_charge
      t.string            :combo_parent
      t.string            :step,                 default: 'started'
      t.timestamps
    end
     add_index :bill_detail_backups, [:bill_master_backup_id, :auto_no], unique: true
     add_index :bill_detail_backups, :item_id
  end
end