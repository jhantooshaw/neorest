class CreateBillGroups < ActiveRecord::Migration
  def change
    create_table :bill_groups do |t| 
      t.references       :location
      t.string           :name      
      t.timestamps
    end
    add_index :bill_groups, [:location_id, :name], unique: true
  end
end
