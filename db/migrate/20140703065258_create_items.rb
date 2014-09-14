class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references       :location
      t.references       :outlet
      t.references       :item_group                  # find item group
      t.references       :item_sub_group              # find item sub group
      t.string           :code_no
      t.string           :description
      t.float            :rate
      t.float            :rate2
      t.float            :mrp
      t.boolean          :is_taxable,        default: true
      t.string           :excisable
      t.string           :discountable
      t.string           :disable
      t.float            :dsale
      t.float            :svalue
      t.float            :canceled_qty
      t.float            :canceled_amount
      t.string           :under
      t.integer          :item_groups_kot_id         # find item groups kot
      t.float            :service_charge
      t.string           :event
      t.string           :i_alias
      t.string           :kot_printer
      t.integer          :kot_printer_position
      t.references       :bill_group
      t.boolean          :is_special,       default: false
      t.boolean          :is_active,        default: true      
      t.float            :cost
      t.boolean          :open_item 
      t.timestamps
    end
    add_index :items, [:location_id, :outlet_id, :code_no], name: 'by_location_outlet_code_no', unique: true
    add_index :items, :outlet_id
    add_index :items, :code_no
    add_index :items, :item_group_id 
    add_index :items, :item_sub_group_id 
    add_index :items, :item_groups_kot_id 
  end
end