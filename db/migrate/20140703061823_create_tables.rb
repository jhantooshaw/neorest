class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.references       :location
      t.references       :outlet
      t.string           :t_name
      t.integer          :max_pax
      t.integer          :position
      t.references       :table_section         # find data
      t.boolean          :inUse,                :default  => false
      t.string           :tax3app
      t.timestamps
    end
    add_index :tables, [:location_id, :t_name, :position], name: 'by_location_table', unique: true
  end
end