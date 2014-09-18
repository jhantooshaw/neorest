class CreateBillDetails < ActiveRecord::Migration
  def change
    test = Rails.env.development? ? "ENGINE=MyISAM" : ""
    create_table :bill_details, options: test do |t|
      t.references       :client
      t.references       :financial_year
      t.references       :location
      t.references       :outlet
      t.references       :bill_master  # find bill master    
      t.string           :auto_no
      t.string           :serial_no
      t.references       :item        # find item
      t.float          :rate
      t.integer          :qty
      t.float          :amount
      t.float          :excise_amount
      t.string           :taxable
      t.string           :excisable
      t.string           :discountable
      t.boolean          :quety
      t.float          :tax
      t.float          :total
      t.string           :canceled
      t.string           :under
      t.integer          :add_qty
      t.string           :kot
      t.datetime         :kot_time
      t.float          :mrp
      t.float          :s_charge
      t.string           :combo_parent      
      t.timestamps
    end
  end
end
