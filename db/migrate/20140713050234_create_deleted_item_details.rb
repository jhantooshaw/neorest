class CreateDeletedItemDetails < ActiveRecord::Migration
  def change
    create_table :deleted_item_details do |t|
      t.references       :financial_year
      t.references       :location
      t.references       :outlet         
      t.integer          :bill_no
      t.datetime         :bill_date
      t.string           :bill_type
      t.references       :item                # find item
      t.string           :table_no
      t.string           :kot_no
      t.float            :rate
      t.integer          :qty
      t.float            :amount
      t.datetime         :deleted_time
      t.text             :remarks
      t.float            :mrp
      t.string           :cashier
      t.datetime         :kot_time
      t.timestamps
    end
  end
end
