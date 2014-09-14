class CreateItemSubGroups < ActiveRecord::Migration
  def change
    create_table :item_sub_groups do |t|
      t.references       :location
      t.string           :isg_name
      t.timestamps
    end
    add_index :item_sub_groups, [:location_id, :isg_name], name: 'by_location_isg_name', unique: true
  end
end
