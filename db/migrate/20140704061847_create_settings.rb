class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references        :location
      t.references        :outlet  
      t.string            :co_name
      t.integer           :kot_print
      t.integer           :settlement_print
      t.string            :cut_file
      t.integer           :by_waiter
      t.integer           :by_steward
      t.integer           :bill_no_cont
      t.integer           :kot_no_auto      
      t.integer           :bill_print_dos
      t.integer           :bill_width
      t.integer           :bottom_margin
      t.integer           :bill_copies
      t.string            :remarks_item
      t.integer           :cancel_kot_print
      t.integer           :pax
      t.integer           :bar_food_bill_no_sep
      t.integer           :kot_copies
      t.string            :rate_print_in_bill 
      t.integer           :local_kot_print
      t.integer           :single_lane_kot_print
      t.string            :cash_drawer_file
      t.string            :multiple_outlet      
      t.string            :hotel_link
      t.string            :bill_page
      t.string            :kotprint
      t.string            :user_print
      t.string            :save_kot_same_page
      t.boolean           :dsn      
      t.string            :local_comp
      t.string            :remote_comp
      t.integer           :kot_print_group_blank
      t.integer           :waiter_fixed
      t.integer           :first_qty_then_code
      t.string            :menu_outlet_wise
      t.integer           :waiter_common_for_outlet
      t.integer           :warning_msg_date
      t.integer           :user_common_for_outlet
      t.integer           :delivery_settlement_page
      t.string            :multiple_location
      t.boolean           :auto_email      
      t.string            :sender_email
      t.string            :receiver_email
      t.boolean           :save_bill_in_text
      t.string            :file_path
      t.boolean           :combo_offer_for_reverse
      t.string            :logo_print
      t.string            :time_print
      t.boolean           :bill_no_separate_outlet
      t.boolean           :settlement_together
      t.boolean           :update_inv
      t.string            :bar_alias
      t.string            :food_alias
      t.boolean           :touch_screen
      t.boolean           :co_name_print
      t.boolean           :add_print_kot
      t.boolean           :establishment_charge
      t.string            :establishment_on
      t.float             :establishment_perc
      t.boolean           :stub_print
      t.boolean           :amount_in_comp_bill
      t.boolean           :user_print_kot
      t.boolean           :time_print_kot
      t.boolean           :save_time
      t.boolean           :mrp_and_est_show_inbarbill
      t.integer           :pp_for_pc
      t.integer           :pop_for_mic
      t.boolean           :insa_to_deduct_tax2_inc
      t.boolean           :win_bill_line2
      t.boolean           :card_swip
      t.string            :co_no
      t.string            :location_no
      t.string            :bill_win_print_type
      t.integer           :mrp_bill_type
      t.string            :port_no
      t.timestamps
    end
    add_index :settings, [:location_id, :outlet_id], name: 'by_location_outlet', unique: true
  end
end