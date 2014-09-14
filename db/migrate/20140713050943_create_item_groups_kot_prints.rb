class CreateItemGroupsKotPrints < ActiveRecord::Migration
  def change
    create_table :item_groups_kot_prints do |t|
      t.references       :location   
      t.string           :name
      t.timestamps
    end
    add_index :item_groups_kot_prints, [:location_id, :name], unique: true
  end
end
