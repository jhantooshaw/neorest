class CreateComboOffers < ActiveRecord::Migration
  def change
    create_table :combo_offers do |t|
      t.references       :location
      t.references       :outlet       
      t.integer          :combo_cd
      t.string           :combo_code_no
      t.string           :combo_desc
      t.integer          :combo_qty
      t.string           :code_no_offer
      t.string           :desc_offer
      t.integer          :qty_offer
      t.date             :start_date        
      t.date             :end_date        
      t.string           :temp_data
      t.references       :combo_package     
      t.timestamps
    end
    add_index :combo_offers, [:location_id, :outlet_id, :combo_code_no, :code_no_offer], name: 'by_location_outlet_combo', unique: true
    add_index :combo_offers, :outlet_id
    add_index :combo_offers, :combo_code_no
    add_index :combo_offers, :code_no_offer
    add_index :combo_offers, :combo_package_id
  end
end