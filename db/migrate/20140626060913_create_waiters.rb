class CreateWaiters < ActiveRecord::Migration
  def change
    create_table :waiters do |t|
      t.references       :location
      t.references       :outlet
      t.integer          :w_no
      t.string           :w_name
      t.string           :service_charge      
      t.timestamps
    end
    add_index :waiters, [:location_id, :w_no], name: 'by_location_waiter', unique: true
    add_index :waiters, :outlet_id
    add_index :waiters, :w_name
  end
end