class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.references     :location
      t.references     :outlet
      t.string         :name,               null: false, default: ""
      t.string         :encrypted_password, null: false, default: ""
      t.timestamps
    end    
    add_index :staffs, [:location_id, :name], name: 'by_location_staff', unique: true
  end
end
