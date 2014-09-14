class CreateItemGroups < ActiveRecord::Migration
  def change
    create_table :item_groups do |t|
      t.references       :location      
      t.string           :ig_name      
      t.string           :ig_tag
      t.float            :order_kot
      t.timestamps
    end
    add_index :item_groups, [:location_id, :ig_name], name: 'by_location_ig_name', unique: true
  end
end