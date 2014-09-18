class CreateAdjBillDetailBackups < ActiveRecord::Migration
  def change
    test = Rails.env.development? ? "ENGINE=MyISAM" : ""
    create_table :adj_bill_detail_backups, options: test do |t|      
      t.references        :adj_bill_master_backup      # find adj bill master backup
      t.integer           :auto_no
      t.integer           :serial_no
      t.references        :item                        # find item
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
      t.datetime          :kot_time
      t.float             :mrp
      t.float             :s_charge
      t.string            :combo_parent
      t.string            :step,                 default: 'started'
      t.timestamps
    end
     add_index :adj_bill_detail_backups, [:adj_bill_master_backup_id, :auto_no], name: 'by_adj_master_auto_no', unique: true
     add_index :adj_bill_detail_backups, :item_id
  end
end