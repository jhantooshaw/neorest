class CreateComboPackages < ActiveRecord::Migration
  def change
    create_table :combo_packages do |t|
      t.references     :location
      t.string         :name
      t.boolean        :is_active,            default: false
      t.boolean        :linked_happy_hour,    default: false
      t.timestamps
    end
    add_index :combo_packages, [:location_id, :name], name: 'by_location_combo_pkg', unique: true
  end
end