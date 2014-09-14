class CreateOutlets < ActiveRecord::Migration
  def change
    create_table :outlets do |t|
      t.references      :location
      t.string          :name      
      t.boolean         :is_location, :default => false    # if location treat as outlet
      t.timestamps
    end
    add_index :outlets, [:location_id, :name], name: 'by_location_outlet'
  end
end
