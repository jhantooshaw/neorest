class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.references       :location
      t.string           :cc_name
      t.float            :commision_amount, default: 0.0  
      t.timestamps
    end
    add_index :credit_cards, [:location_id, :cc_name], name: 'by_location_cc_name', unique: true
  end
end