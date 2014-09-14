class CreateRemarkMasters < ActiveRecord::Migration
  def change
    create_table :remark_masters do |t|
      t.references       :location
      t.string           :remarks
      t.timestamps
    end
    add_index :remark_masters, [:location_id, :remarks], unique: true
  end
end