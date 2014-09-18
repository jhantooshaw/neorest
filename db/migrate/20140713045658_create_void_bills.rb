class CreateVoidBills < ActiveRecord::Migration
  def change
    create_table :void_bills do |t|
      t.references       :financial_year
      t.references       :location
      t.references       :outlet      
      t.integer          :bill_no
      t.string           :table_no  
      t.datetime         :bill_date
      t.string           :bill_type
      t.datetime         :bill_time
      t.references       :waiter            # find waiter
      t.float            :dis_per
      t.float            :discount
      t.float            :s_tax
      t.float            :total
      t.string           :pay_type
      t.integer          :user_id           # find user
      t.string           :user_name
      t.integer          :modified_by       # find user
      t.string           :modified_name
      t.datetime         :modified_date
      t.string           :modified_time
      t.integer          :cover
      t.text             :comment
      t.integer          :customer_id       # find customer 
      t.string           :customer_name
      t.string           :cc_name
      t.datetime         :settle_time
      t.text             :remarks
      t.string           :step,             default: 'started'
      t.timestamps
    end
    add_index :void_bills, [:location_id, :outlet_id, :bill_no, :bill_date, :bill_type, :financial_year_id], name: 'by_location_outlet_bill_void', unique: true
    add_index :void_bills, :financial_year_id
    add_index :void_bills, :outlet_id
    add_index :void_bills, :bill_no  
    add_index :void_bills, :bill_date  
    add_index :void_bills, :bill_type  
    add_index :void_bills, :waiter_id  
    add_index :void_bills, :customer_id
    add_index :void_bills, :customer_name
    
  end
end