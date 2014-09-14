class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references    :client
      t.string        :name
      t.string        :address
      t.string        :phone
      t.string        :ip
      t.boolean       :has_outlet, default: false
      t.timestamps
    end
    add_index :locations, [:client_id, :name, :address], name: 'by_client_location', unique: true
  end
end