class CreateTableSections < ActiveRecord::Migration
  def change
    create_table :table_sections do |t|
      t.references       :location
      t.references       :outlet      
      t.string           :section
      t.float            :amount
      t.timestamps
    end
    add_index :table_sections, [:location_id, :outlet_id, :section], name: 'by_location_tbl_sec', unique: true
    add_index :table_sections, :outlet_id
    add_index :table_sections, :section
  end
end