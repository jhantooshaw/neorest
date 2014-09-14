class CreateStaffSubMenuSettings < ActiveRecord::Migration
  def change
    create_table :staff_sub_menu_settings do |t|
      t.references    :staff
      t.string        :sub_menu
      t.boolean       :is_add,            default: true   
      t.boolean       :is_find,           default: true   
      t.boolean       :is_edit,           default: true   
      t.boolean       :is_delete,         default: true   
      t.boolean       :is_visible,        default: true   
      t.timestamps
    end
    add_index :staff_sub_menu_settings, [:staff_id, :sub_menu], name: 'by_staff_sub_menu', unique: true
  end
end