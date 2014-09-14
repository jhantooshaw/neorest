class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string          :c_name
      t.string          :c_abbr
      t.timestamps
    end
    add_index :countries, :c_name, unique: true
    add_index :countries, :c_abbr
  end
end
