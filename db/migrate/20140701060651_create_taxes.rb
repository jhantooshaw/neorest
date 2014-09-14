class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.references       :location
      t.references       :outlet
      t.integer          :tax_auto_id
      t.float            :tax1_per
      t.string           :tax1_name,        default: ""
      t.float            :tax2_per,         default: 0
      t.string           :tax2_name,        default: ""
      t.float            :tax3_per,         default: 0
      t.string           :tax3_name,        default: ""
      t.float            :tax4_per,         default: 0
      t.string           :tax4_name,        default: ""
      t.float            :tax5_per,         default: 0
      t.string           :tax5_name,        default: ""
      t.string           :tax_cal_after_dis
      t.string           :rate_incd_of_stax
      t.boolean          :service_tax_applicable
      t.float            :service_tax
      t.float            :edu_tax
      t.float            :hs_edu_tax
      t.float            :abatement
      t.boolean          :rate_incd_of_tax1
      t.boolean          :show_tax1_incl_in_bill
      t.boolean          :tax1_cal_last
      t.boolean          :st_on_tax4_applicable
      t.float            :st_per_on_tax4,         default: 0
      t.timestamps
    end
    add_index :taxes, [:location_id, :tax_auto_id], name: 'by_location_tax', unique: true
    add_index :taxes, :outlet_id
  end
end