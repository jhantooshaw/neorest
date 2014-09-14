class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references       :location   
      t.integer          :membership_no
      t.string           :c_name
      t.string           :address1
      t.string           :address2
      t.string           :zipcode
      t.string           :phone1
      t.string           :phone2
      t.string           :mobile
      t.string           :fax
      t.date             :dob
      t.date             :ann
      t.datetime         :entry_date
      t.string           :email
      t.float            :dis_per
      t.datetime         :order_date
      t.text             :remarks
      t.string           :membership_no_manual
      t.string           :card_no      
      t.timestamps
    end
    add_index :customers, [:location_id, :membership_no, :c_name], name: 'by_location_customer', unique: true
  end
end