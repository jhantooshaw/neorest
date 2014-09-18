class CreateCompBillMasterBackups < ActiveRecord::Migration
  def change
    test = Rails.env.development? ? "ENGINE=MyISAM" : ""
    create_table :comp_bill_master_backups, options: test do |t|
      t.references       :financial_year
      t.references       :location
      t.references       :outlet      
      t.integer          :bill_no
      t.string           :table_no
      t.datetime         :bill_date
      t.datetime         :bill_time 
      t.references       :waiter            # find waiter
      t.references       :steward           # find steward
      t.float            :total
      t.integer          :user_id           # find user
      t.string           :user_name
      t.integer          :modified_by       # find user
      t.string           :modified_name
      t.datetime         :modified_date
      t.text             :comment
      t.string           :canceled
      t.float            :exciseable_amount
      t.float            :excise_amount
      t.integer          :cover
      t.integer          :customer_id       # find customer 
      t.string           :customer_name
      t.string           :room_no
      t.datetime         :hotel_date
      t.string           :step,                 default: 'started'
      t.timestamps
    end
    add_index :comp_bill_master_backups, [:location_id, :outlet_id, :bill_no, :bill_date, :financial_year_id], name: 'by_location_outlet_bill', unique: true
    add_index :comp_bill_master_backups, :financial_year_id
    add_index :comp_bill_master_backups, :outlet_id
    add_index :comp_bill_master_backups, :bill_no    
    add_index :comp_bill_master_backups, :bill_date    
    add_index :comp_bill_master_backups, :waiter_id    
    add_index :comp_bill_master_backups, :steward_id    
    add_index :comp_bill_master_backups, :customer_id
    add_index :comp_bill_master_backups, :customer_name
  end
end
