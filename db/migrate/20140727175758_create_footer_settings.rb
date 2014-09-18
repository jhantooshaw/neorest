class CreateFooterSettings < ActiveRecord::Migration
  def change
    create_table :footer_settings do |t|
      t.references       :location
      t.references       :outlet 
      t.integer          :header_id
      t.string           :header,               default: ""
      t.string           :footer_one,           default: ""
      t.string           :footer_two,           default: ""
      t.string           :footer_three,         default: ""
      t.string           :footer_four,          default: ""
      t.timestamps
    end
    add_index :footer_settings, [:location_id, :outlet_id, :header_id], name: 'by_loc_out_header',  unique: true
    add_index :footer_settings, :outlet_id
    add_index :footer_settings, :header
  end
end
