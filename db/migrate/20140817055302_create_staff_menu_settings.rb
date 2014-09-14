class CreateStaffMenuSettings < ActiveRecord::Migration
  def change
    create_table :staff_menu_settings do |t|
      t.references    :staff
      t.string        :menu
      t.boolean       :is_visible,        default: true   
      t.timestamps
    end
    add_index :staff_menu_settings, [:staff_id, :menu], name: 'by_staff_menu', unique: true    
  end
end