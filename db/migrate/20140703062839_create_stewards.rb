class CreateStewards < ActiveRecord::Migration
  def change
    create_table :stewards do |t|
      t.references       :location
      t.references       :outlet      
      t.integer          :s_no       
      t.string           :s_name
      t.float            :sale_ratio      
      t.timestamps
    end
    add_index :stewards, [:location_id, :s_no, :s_name], name: 'by_location_steward'
    add_index :stewards, :outlet_id
    add_index :stewards, :s_name
  end
end