class CreateBillMasters < ActiveRecord::Migration
  def change
    test = Rails.env.development? ? "ENGINE=MyISAM" : ""
    create_table :bill_master, options: test do |t|
      t.references       :client
      t.references       :financial_year
      t.references       :location
      t.references       :outlet      
      t.integer          :bill_no
      t.string           :table_no  
      t.datetime         :bill_date
      t.string           :bill_type
      t.datetime         :bill_time  
      t.references       :waiter                  # find waiter
      t.references       :steward                 # find steward
      t.float            :dis_per
      t.float            :discount
      t.references       :tax                     # find tax      
      t.float            :service_tax_per
      t.float            :service_tax
      t.float            :edu_tax_per
      t.float            :edu_tax
      t.float            :hs_edu_tax_per
      t.float            :hs_edu_tax
      t.string           :tax1
      t.string           :tax1_per
      t.float            :tax1_amount
      t.string           :tax2
      t.string           :tax2_per
      t.float            :tax2_amount
      t.string           :tax3
      t.string           :tax3_per
      t.float            :tax3_amount
      t.string           :tax4
      t.string           :tax4_per
      t.float            :tax4_amount
      t.string           :tax5
      t.string           :tax5_per
      t.float            :tax5_amount
      t.float            :s_tax      
      t.float            :excise_amount
      t.float            :round_off
      t.float            :net_amount
      t.float            :total_amount
      t.float            :sub_total_amount
      t.float            :taxable_amount
      t.float            :non_taxable_amount
      t.float            :exciseable_amount
      t.string           :pay_type
      t.integer          :user_id         # find user
      t.string           :user_name
      t.integer          :modified_by     # find user
      t.string           :modified_name
      t.datetime         :modified_date
      t.string           :modified_time
      t.string           :canceled
      t.integer          :cover
      t.text             :comment
      t.integer          :customer_id    # find customer 
      t.string           :customer
      t.string           :delivery
      t.string           :cc_name
      t.float            :actual_amount
      t.float            :food_amount
      t.float            :food_tax
      t.float            :food_total
      t.float            :beverage_amount
      t.float            :beverage_tax
      t.float            :beverage_total
      t.float            :wine_amount
      t.float            :beer_amount
      t.float            :cal_sub_total
      t.float            :tips
      t.float            :grand_total
      t.datetime         :settle_time
      t.integer          :no_of_print
      t.float            :pay_changed
      t.float            :dis_food
      t.float            :dis_liquer
      t.float            :dis_both
      t.string           :room_no
      t.datetime         :hotel_date
      t.string           :banquet
      t.datetime         :out_time
      t.string           :linked_financial_year 
      t.boolean          :rate_incd_of_tax1
      t.string           :tax_cal_after_dis
      t.string           :rate_incd_of_stax
      t.boolean          :service_tax_applicable
      t.float            :abatement
      t.boolean          :tax1_cal_last
      t.timestamps
    end
  end
end