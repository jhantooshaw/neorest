class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string          :s_name
      t.string          :s_abbr
      t.references      :country
      t.timestamps
    end
    add_index :states, [:country_id, :s_name, :s_abbr], unique: true
  end
end