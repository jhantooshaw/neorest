# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140820180523) do

  create_table "adj_bill_detail_backups", force: true do |t|
    t.integer  "adj_bill_master_backup_id"
    t.integer  "auto_no"
    t.integer  "serial_no"
    t.integer  "item_id"
    t.float    "rate"
    t.integer  "qty"
    t.float    "amount"
    t.float    "excise_amount"
    t.string   "taxable"
    t.string   "excisable"
    t.string   "discountable"
    t.boolean  "quety"
    t.float    "tax"
    t.float    "total"
    t.string   "canceled"
    t.string   "under"
    t.integer  "add_qty"
    t.string   "kot"
    t.datetime "kot_time"
    t.float    "mrp"
    t.float    "s_charge"
    t.string   "combo_parent"
    t.string   "step",                      default: "started"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adj_bill_detail_backups", ["adj_bill_master_backup_id", "auto_no"], name: "by_adj_master_auto_no", unique: true, using: :btree
  add_index "adj_bill_detail_backups", ["item_id"], name: "index_adj_bill_detail_backups_on_item_id", using: :btree

  create_table "adj_bill_master_backups", force: true do |t|
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "bill_no"
    t.string   "table_no"
    t.datetime "bill_date"
    t.string   "bill_type"
    t.datetime "bill_time"
    t.integer  "waiter_id"
    t.integer  "steward_id"
    t.float    "dis_per"
    t.float    "discount"
    t.integer  "tax_id"
    t.float    "service_tax_per"
    t.float    "service_tax"
    t.float    "edu_tax_per"
    t.float    "edu_tax"
    t.float    "hs_edu_tax_per"
    t.float    "hs_edu_tax"
    t.string   "tax1"
    t.float    "tax1_per"
    t.float    "tax1_amount"
    t.string   "tax2"
    t.float    "tax2_per"
    t.float    "tax2_amount"
    t.string   "tax3"
    t.float    "tax3_per"
    t.float    "tax3_amount"
    t.string   "tax4"
    t.float    "tax4_per"
    t.float    "tax4_amount"
    t.string   "tax5"
    t.float    "tax5_per"
    t.float    "tax5_amount"
    t.float    "s_tax"
    t.float    "excise_amount"
    t.float    "round_off"
    t.float    "net_amount"
    t.float    "total_amount"
    t.float    "sub_total_amount"
    t.float    "taxable_amount"
    t.float    "non_taxable_amount"
    t.float    "exciseable_amount"
    t.string   "pay_type"
    t.integer  "staff_id"
    t.string   "staff_name"
    t.integer  "modified_by"
    t.string   "modified_name"
    t.datetime "modified_date"
    t.string   "modified_time"
    t.string   "canceled"
    t.integer  "cover"
    t.text     "comment"
    t.integer  "customer_id"
    t.string   "customer_name"
    t.string   "delivery"
    t.string   "cc_name"
    t.float    "actual_amount"
    t.float    "food_amount"
    t.float    "food_tax"
    t.float    "food_total"
    t.float    "beverage_amount"
    t.float    "beverage_tax"
    t.float    "beverage_total"
    t.float    "wine_amount"
    t.float    "beer_amount"
    t.float    "cal_sub_total"
    t.float    "tips"
    t.float    "grand_total"
    t.string   "settle_time"
    t.integer  "no_of_print"
    t.float    "pay_changed"
    t.float    "dis_food"
    t.float    "dis_liquer"
    t.float    "dis_both"
    t.string   "room_no"
    t.datetime "hotel_date"
    t.string   "banquet"
    t.datetime "out_time"
    t.boolean  "rate_incd_of_tax1"
    t.string   "tax_cal_after_dis"
    t.boolean  "rate_incd_of_stax"
    t.boolean  "service_tax_applicable"
    t.float    "abatement"
    t.boolean  "tax1_cal_last"
    t.string   "linked_financial_year"
    t.boolean  "stontax4"
    t.float    "stontax4_per"
    t.float    "stontax4_amount"
    t.string   "step",                   default: "started"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adj_bill_master_backups", ["bill_date"], name: "index_adj_bill_master_backups_on_bill_date", using: :btree
  add_index "adj_bill_master_backups", ["bill_no"], name: "index_adj_bill_master_backups_on_bill_no", using: :btree
  add_index "adj_bill_master_backups", ["canceled"], name: "index_adj_bill_master_backups_on_canceled", using: :btree
  add_index "adj_bill_master_backups", ["customer_id"], name: "index_adj_bill_master_backups_on_customer_id", using: :btree
  add_index "adj_bill_master_backups", ["customer_name"], name: "index_adj_bill_master_backups_on_customer_name", using: :btree
  add_index "adj_bill_master_backups", ["financial_year_id"], name: "index_adj_bill_master_backups_on_financial_year_id", using: :btree
  add_index "adj_bill_master_backups", ["location_id", "outlet_id", "bill_no", "bill_date", "bill_type", "financial_year_id"], name: "by_location_outlet_bill_adj", unique: true, using: :btree
  add_index "adj_bill_master_backups", ["outlet_id"], name: "index_adj_bill_master_backups_on_outlet_id", using: :btree
  add_index "adj_bill_master_backups", ["pay_type"], name: "index_adj_bill_master_backups_on_pay_type", using: :btree

  create_table "adj_bill_settlements", force: true do |t|
    t.integer  "adj_bill_master_backup_id"
    t.integer  "auto_no"
    t.string   "pay_type"
    t.float    "pay_amount"
    t.string   "cc_name"
    t.string   "cashier"
    t.integer  "customer_id"
    t.string   "customer_name"
    t.string   "table_no"
    t.text     "comment"
    t.float    "tips"
    t.string   "room_no"
    t.datetime "hotel_date"
    t.string   "manager_bit"
    t.datetime "manager_date"
    t.string   "step",                      default: "started"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adj_bill_settlements", ["adj_bill_master_backup_id", "auto_no"], name: "by_adj_bill_master_auto_no", unique: true, using: :btree
  add_index "adj_bill_settlements", ["customer_id"], name: "index_adj_bill_settlements_on_customer_id", using: :btree
  add_index "adj_bill_settlements", ["customer_name"], name: "index_adj_bill_settlements_on_customer_name", using: :btree
  add_index "adj_bill_settlements", ["manager_bit"], name: "index_adj_bill_settlements_on_manager_bit", using: :btree
  add_index "adj_bill_settlements", ["pay_type"], name: "index_adj_bill_settlements_on_pay_type", using: :btree

  create_table "bill_detail_backups", force: true do |t|
    t.integer  "bill_master_backup_id"
    t.integer  "auto_no"
    t.integer  "serial_no"
    t.integer  "item_id"
    t.float    "rate"
    t.integer  "qty"
    t.float    "amount"
    t.float    "excise_amount"
    t.string   "taxable"
    t.string   "excisable"
    t.string   "discountable"
    t.boolean  "quety"
    t.float    "tax"
    t.float    "total"
    t.string   "canceled"
    t.string   "under"
    t.integer  "add_qty"
    t.string   "kot"
    t.string   "kot_time"
    t.float    "mrp"
    t.float    "s_charge"
    t.string   "combo_parent"
    t.string   "step",                  default: "started"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_detail_backups", ["bill_master_backup_id", "auto_no"], name: "index_bill_detail_backups_on_bill_master_backup_id_and_auto_no", unique: true, using: :btree
  add_index "bill_detail_backups", ["item_id"], name: "index_bill_detail_backups_on_item_id", using: :btree

  create_table "bill_details", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "bill_master_id"
    t.string   "auto_no"
    t.string   "serial_no"
    t.integer  "item_id"
    t.float    "rate"
    t.integer  "qty"
    t.float    "amount"
    t.float    "excise_amount"
    t.string   "taxable"
    t.string   "excisable"
    t.string   "discountable"
    t.boolean  "quety"
    t.float    "tax"
    t.float    "total"
    t.string   "canceled"
    t.string   "under"
    t.integer  "add_qty"
    t.string   "kot"
    t.datetime "kot_time"
    t.float    "mrp"
    t.float    "s_charge"
    t.string   "combo_parent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bill_groups", force: true do |t|
    t.integer  "location_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_groups", ["location_id", "name"], name: "index_bill_groups_on_location_id_and_name", unique: true, using: :btree

  create_table "bill_master", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "bill_no"
    t.string   "table_no"
    t.datetime "bill_date"
    t.string   "bill_type"
    t.datetime "bill_time"
    t.integer  "waiter_id"
    t.integer  "steward_id"
    t.float    "dis_per"
    t.float    "discount"
    t.integer  "tax_id"
    t.float    "service_tax_per"
    t.float    "service_tax"
    t.float    "edu_tax_per"
    t.float    "edu_tax"
    t.float    "hs_edu_tax_per"
    t.float    "hs_edu_tax"
    t.string   "tax1"
    t.string   "tax1_per"
    t.float    "tax1_amount"
    t.string   "tax2"
    t.string   "tax2_per"
    t.float    "tax2_amount"
    t.string   "tax3"
    t.string   "tax3_per"
    t.float    "tax3_amount"
    t.string   "tax4"
    t.string   "tax4_per"
    t.float    "tax4_amount"
    t.string   "tax5"
    t.string   "tax5_per"
    t.float    "tax5_amount"
    t.float    "s_tax"
    t.float    "excise_amount"
    t.float    "round_off"
    t.float    "net_amount"
    t.float    "total_amount"
    t.float    "sub_total_amount"
    t.float    "taxable_amount"
    t.float    "non_taxable_amount"
    t.float    "exciseable_amount"
    t.string   "pay_type"
    t.integer  "staff_id"
    t.string   "staff_name"
    t.integer  "modified_by"
    t.string   "modified_name"
    t.datetime "modified_date"
    t.string   "modified_time"
    t.string   "canceled"
    t.integer  "cover"
    t.text     "comment"
    t.integer  "customer_id"
    t.string   "customer"
    t.string   "delivery"
    t.string   "cc_name"
    t.float    "actual_amount"
    t.float    "food_amount"
    t.float    "food_tax"
    t.float    "food_total"
    t.float    "beverage_amount"
    t.float    "beverage_tax"
    t.float    "beverage_total"
    t.float    "wine_amount"
    t.float    "beer_amount"
    t.float    "cal_sub_total"
    t.float    "tips"
    t.float    "grand_total"
    t.datetime "settle_time"
    t.integer  "no_of_print"
    t.float    "pay_changed"
    t.float    "dis_food"
    t.float    "dis_liquer"
    t.float    "dis_both"
    t.string   "room_no"
    t.datetime "hotel_date"
    t.string   "banquet"
    t.datetime "out_time"
    t.string   "linked_financial_year"
    t.boolean  "rate_incd_of_tax1"
    t.string   "tax_cal_after_dis"
    t.string   "rate_incd_of_stax"
    t.boolean  "service_tax_applicable"
    t.float    "abatement"
    t.boolean  "tax1_cal_last"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bill_master_backups", force: true do |t|
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "bill_no"
    t.string   "table_no"
    t.datetime "bill_date"
    t.string   "bill_type"
    t.datetime "bill_time"
    t.integer  "waiter_id"
    t.integer  "steward_id"
    t.float    "dis_per"
    t.float    "discount"
    t.integer  "tax_id"
    t.float    "service_tax_per"
    t.float    "service_tax"
    t.float    "edu_tax_per"
    t.float    "edu_tax"
    t.float    "hs_edu_tax_per"
    t.float    "hs_edu_tax"
    t.string   "tax1"
    t.float    "tax1_per"
    t.float    "tax1_amount"
    t.string   "tax2"
    t.float    "tax2_per"
    t.float    "tax2_amount"
    t.string   "tax3"
    t.float    "tax3_per"
    t.float    "tax3_amount"
    t.string   "tax4"
    t.float    "tax4_per"
    t.float    "tax4_amount"
    t.string   "tax5"
    t.float    "tax5_per"
    t.float    "tax5_amount"
    t.float    "s_tax"
    t.float    "excise_amount"
    t.float    "round_off"
    t.float    "net_amount"
    t.float    "total_amount"
    t.float    "sub_total_amount"
    t.float    "taxable_amount"
    t.float    "non_taxable_amount"
    t.float    "exciseable_amount"
    t.string   "pay_type"
    t.integer  "staff_id"
    t.string   "staff_name"
    t.integer  "modified_by"
    t.string   "modified_name"
    t.datetime "modified_date"
    t.string   "modified_time"
    t.string   "canceled"
    t.integer  "cover"
    t.text     "comment"
    t.integer  "customer_id"
    t.string   "customer_name"
    t.string   "delivery"
    t.string   "cc_name"
    t.float    "actual_amount"
    t.float    "food_amount"
    t.float    "food_tax"
    t.float    "food_total"
    t.float    "beverage_amount"
    t.float    "beverage_tax"
    t.float    "beverage_total"
    t.float    "wine_amount"
    t.float    "beer_amount"
    t.float    "cal_sub_total"
    t.float    "tips"
    t.float    "grand_total"
    t.string   "settle_time"
    t.integer  "no_of_print"
    t.float    "pay_changed"
    t.float    "dis_food"
    t.float    "dis_liquer"
    t.float    "dis_both"
    t.string   "room_no"
    t.datetime "hotel_date"
    t.string   "banquet"
    t.datetime "out_time"
    t.boolean  "rate_incd_of_tax1"
    t.string   "tax_cal_after_dis"
    t.boolean  "rate_incd_of_stax"
    t.boolean  "service_tax_applicable"
    t.float    "abatement"
    t.boolean  "tax1_cal_last"
    t.string   "linked_financial_year"
    t.boolean  "stontax4"
    t.float    "stontax4_per"
    t.float    "stontax4_amount"
    t.string   "step",                   default: "started"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_master_backups", ["bill_date"], name: "index_bill_master_backups_on_bill_date", using: :btree
  add_index "bill_master_backups", ["bill_no"], name: "index_bill_master_backups_on_bill_no", using: :btree
  add_index "bill_master_backups", ["canceled"], name: "index_bill_master_backups_on_canceled", using: :btree
  add_index "bill_master_backups", ["customer_id"], name: "index_bill_master_backups_on_customer_id", using: :btree
  add_index "bill_master_backups", ["customer_name"], name: "index_bill_master_backups_on_customer_name", using: :btree
  add_index "bill_master_backups", ["financial_year_id"], name: "index_bill_master_backups_on_financial_year_id", using: :btree
  add_index "bill_master_backups", ["location_id", "outlet_id", "bill_no", "bill_date", "bill_type", "financial_year_id"], name: "by_location_outlet_bill_master", unique: true, using: :btree
  add_index "bill_master_backups", ["outlet_id"], name: "index_bill_master_backups_on_outlet_id", using: :btree
  add_index "bill_master_backups", ["pay_type"], name: "index_bill_master_backups_on_pay_type", using: :btree

  create_table "bill_settlements", force: true do |t|
    t.integer  "bill_master_backup_id"
    t.integer  "auto_no"
    t.string   "pay_type"
    t.float    "pay_amount"
    t.string   "cc_name"
    t.string   "cashier"
    t.integer  "customer_id"
    t.string   "customer_name"
    t.string   "table_no"
    t.text     "comment"
    t.float    "tips"
    t.string   "room_no"
    t.datetime "hotel_date"
    t.string   "manager_bit"
    t.datetime "manager_date"
    t.string   "step",                  default: "started"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_settlements", ["bill_master_backup_id", "auto_no"], name: "index_bill_settlements_on_bill_master_backup_id_and_auto_no", unique: true, using: :btree
  add_index "bill_settlements", ["cc_name"], name: "index_bill_settlements_on_cc_name", using: :btree
  add_index "bill_settlements", ["customer_id"], name: "index_bill_settlements_on_customer_id", using: :btree
  add_index "bill_settlements", ["customer_name"], name: "index_bill_settlements_on_customer_name", using: :btree
  add_index "bill_settlements", ["manager_bit"], name: "index_bill_settlements_on_manager_bit", using: :btree
  add_index "bill_settlements", ["pay_type"], name: "index_bill_settlements_on_pay_type", using: :btree

  create_table "clients", force: true do |t|
    t.string   "hotel_name",             default: ""
    t.string   "phone",                  default: ""
    t.string   "mobile",                 default: ""
    t.string   "address",                default: ""
    t.string   "city",                   default: ""
    t.string   "zipcode",                default: ""
    t.string   "subdomain"
    t.integer  "state_id"
    t.integer  "country_id"
    t.string   "roles_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
  end

  add_index "clients", ["email"], name: "index_clients_on_email", unique: true, using: :btree
  add_index "clients", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true, using: :btree
  add_index "clients", ["subdomain"], name: "index_clients_on_subdomain", unique: true, using: :btree

  create_table "combo_offers", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "combo_cd"
    t.string   "combo_code_no"
    t.string   "combo_desc"
    t.integer  "combo_qty"
    t.string   "code_no_offer"
    t.string   "desc_offer"
    t.integer  "qty_offer"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "temp_data"
    t.integer  "combo_package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "combo_offers", ["code_no_offer"], name: "index_combo_offers_on_code_no_offer", using: :btree
  add_index "combo_offers", ["combo_code_no"], name: "index_combo_offers_on_combo_code_no", using: :btree
  add_index "combo_offers", ["combo_package_id"], name: "index_combo_offers_on_combo_package_id", using: :btree
  add_index "combo_offers", ["location_id", "outlet_id", "combo_code_no", "code_no_offer"], name: "by_location_outlet_combo", unique: true, using: :btree
  add_index "combo_offers", ["outlet_id"], name: "index_combo_offers_on_outlet_id", using: :btree

  create_table "combo_packages", force: true do |t|
    t.integer  "location_id"
    t.string   "name"
    t.boolean  "is_active",         default: false
    t.boolean  "linked_happy_hour", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "combo_packages", ["location_id", "name"], name: "by_location_combo_pkg", unique: true, using: :btree

  create_table "comp_bill_detail_backups", force: true do |t|
    t.integer  "comp_bill_master_backup_id"
    t.integer  "auto_no"
    t.integer  "serial_no"
    t.integer  "item_id"
    t.float    "rate"
    t.integer  "qty"
    t.float    "amount"
    t.boolean  "quety"
    t.string   "canceled"
    t.string   "excisable"
    t.float    "excise_amount"
    t.float    "mrp"
    t.string   "combo_parent"
    t.datetime "kot_time"
    t.string   "step",                       default: "started"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comp_bill_detail_backups", ["comp_bill_master_backup_id", "auto_no"], name: "by_comp_master_auto_no", unique: true, using: :btree
  add_index "comp_bill_detail_backups", ["item_id"], name: "index_comp_bill_detail_backups_on_item_id", using: :btree

  create_table "comp_bill_master_backups", force: true do |t|
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "bill_no"
    t.string   "table_no"
    t.datetime "bill_date"
    t.datetime "bill_time"
    t.integer  "waiter_id"
    t.integer  "steward_id"
    t.float    "total"
    t.integer  "staff_id"
    t.string   "staff_name"
    t.integer  "modified_by"
    t.string   "modified_name"
    t.datetime "modified_date"
    t.text     "comment"
    t.string   "canceled"
    t.float    "exciseable_amount"
    t.float    "excise_amount"
    t.integer  "cover"
    t.integer  "customer_id"
    t.string   "customer_name"
    t.string   "room_no"
    t.datetime "hotel_date"
    t.string   "step",              default: "started"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comp_bill_master_backups", ["bill_date"], name: "index_comp_bill_master_backups_on_bill_date", using: :btree
  add_index "comp_bill_master_backups", ["bill_no"], name: "index_comp_bill_master_backups_on_bill_no", using: :btree
  add_index "comp_bill_master_backups", ["customer_id"], name: "index_comp_bill_master_backups_on_customer_id", using: :btree
  add_index "comp_bill_master_backups", ["customer_name"], name: "index_comp_bill_master_backups_on_customer_name", using: :btree
  add_index "comp_bill_master_backups", ["financial_year_id"], name: "index_comp_bill_master_backups_on_financial_year_id", using: :btree
  add_index "comp_bill_master_backups", ["location_id", "outlet_id", "bill_no", "bill_date", "financial_year_id"], name: "by_location_outlet_bill_comp", unique: true, using: :btree
  add_index "comp_bill_master_backups", ["outlet_id"], name: "index_comp_bill_master_backups_on_outlet_id", using: :btree
  add_index "comp_bill_master_backups", ["steward_id"], name: "index_comp_bill_master_backups_on_steward_id", using: :btree
  add_index "comp_bill_master_backups", ["waiter_id"], name: "index_comp_bill_master_backups_on_waiter_id", using: :btree

  create_table "companies", force: true do |t|
    t.integer  "client_id"
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "address4"
    t.string   "address5"
    t.string   "phone"
    t.string   "other"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["client_id", "name", "address1"], name: "by_client_company", unique: true, using: :btree
  add_index "companies", ["name"], name: "index_companies_on_name", using: :btree

  create_table "countries", force: true do |t|
    t.string   "c_name"
    t.string   "c_abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["c_abbr"], name: "index_countries_on_c_abbr", using: :btree
  add_index "countries", ["c_name"], name: "index_countries_on_c_name", unique: true, using: :btree

  create_table "credit_cards", force: true do |t|
    t.integer  "location_id"
    t.string   "cc_name"
    t.float    "commision_amount", default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_cards", ["location_id", "cc_name"], name: "by_location_cc_name", unique: true, using: :btree

  create_table "customers", force: true do |t|
    t.integer  "location_id"
    t.integer  "membership_no"
    t.string   "c_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "zipcode"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "mobile"
    t.string   "fax"
    t.date     "dob"
    t.date     "ann"
    t.datetime "entry_date"
    t.string   "email"
    t.float    "dis_per"
    t.datetime "order_date"
    t.text     "remarks"
    t.string   "membership_no_manual"
    t.string   "card_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["location_id", "membership_no", "c_name"], name: "by_location_customer", unique: true, using: :btree

  create_table "deleted_item_details", force: true do |t|
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "bill_no"
    t.datetime "bill_date"
    t.string   "bill_type"
    t.integer  "item_id"
    t.string   "table_no"
    t.string   "kot_no"
    t.float    "rate"
    t.integer  "qty"
    t.float    "amount"
    t.datetime "deleted_time"
    t.text     "remarks"
    t.float    "mrp"
    t.string   "cashier"
    t.datetime "kot_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "financial_years", force: true do |t|
    t.string   "name",       default: "", null: false
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "financial_years", ["client_id", "name", "start_date", "end_date"], name: "by_client_fin_year", unique: true, using: :btree

  create_table "financial_years_locations", id: false, force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "financial_years_locations", ["client_id", "financial_year_id", "location_id"], name: "by_client_fin_loc", unique: true, using: :btree

  create_table "footer_settings", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "header_id"
    t.string   "header",       default: ""
    t.string   "footer_one",   default: ""
    t.string   "footer_two",   default: ""
    t.string   "footer_three", default: ""
    t.string   "footer_four",  default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "footer_settings", ["header"], name: "index_footer_settings_on_header", using: :btree
  add_index "footer_settings", ["location_id", "outlet_id", "header_id"], name: "by_loc_out_header", unique: true, using: :btree
  add_index "footer_settings", ["outlet_id"], name: "index_footer_settings_on_outlet_id", using: :btree

  create_table "happy_hours", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "happy_hour_cd"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "combo_package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "happy_hours", ["combo_package_id"], name: "index_happy_hours_on_combo_package_id", using: :btree
  add_index "happy_hours", ["happy_hour_cd"], name: "index_happy_hours_on_happy_hour_cd", using: :btree
  add_index "happy_hours", ["location_id", "outlet_id", "happy_hour_cd"], name: "by_loc_out_happy_hour", unique: true, using: :btree
  add_index "happy_hours", ["outlet_id"], name: "index_happy_hours_on_outlet_id", using: :btree

  create_table "item_groups", force: true do |t|
    t.integer  "location_id"
    t.string   "ig_name"
    t.string   "ig_tag"
    t.float    "order_kot"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_groups", ["location_id", "ig_name"], name: "by_location_ig_name", unique: true, using: :btree

  create_table "item_groups_kot_prints", force: true do |t|
    t.integer  "location_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_groups_kot_prints", ["location_id", "name"], name: "index_item_groups_kot_prints_on_location_id_and_name", unique: true, using: :btree

  create_table "item_sub_groups", force: true do |t|
    t.integer  "location_id"
    t.string   "isg_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_sub_groups", ["location_id", "isg_name"], name: "by_location_isg_name", unique: true, using: :btree

  create_table "items", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "item_group_id"
    t.integer  "item_sub_group_id"
    t.string   "code_no"
    t.string   "description"
    t.float    "rate"
    t.float    "rate2"
    t.float    "mrp"
    t.boolean  "is_taxable",               default: true
    t.string   "excisable"
    t.string   "discountable"
    t.string   "disable"
    t.float    "dsale"
    t.float    "svalue"
    t.float    "canceled_qty"
    t.float    "canceled_amount"
    t.string   "under"
    t.integer  "item_groups_kot_print_id"
    t.float    "service_charge"
    t.string   "event"
    t.string   "i_alias"
    t.string   "kot_printer"
    t.integer  "kot_printer_position"
    t.integer  "bill_group_id"
    t.boolean  "is_special",               default: false
    t.boolean  "is_active",                default: true
    t.float    "cost"
    t.boolean  "open_item"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["bill_group_id"], name: "index_items_on_bill_group_id", using: :btree
  add_index "items", ["code_no"], name: "index_items_on_code_no", using: :btree
  add_index "items", ["item_group_id"], name: "index_items_on_item_group_id", using: :btree
  add_index "items", ["item_groups_kot_print_id"], name: "index_items_on_item_groups_kot_print_id", using: :btree
  add_index "items", ["item_sub_group_id"], name: "index_items_on_item_sub_group_id", using: :btree
  add_index "items", ["location_id", "outlet_id", "code_no"], name: "by_location_outlet_code_no", unique: true, using: :btree
  add_index "items", ["outlet_id"], name: "index_items_on_outlet_id", using: :btree

  create_table "locations", force: true do |t|
    t.integer  "client_id"
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "ip"
    t.boolean  "has_outlet", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["client_id", "name", "address"], name: "by_client_location", unique: true, using: :btree

  create_table "outlets", force: true do |t|
    t.integer  "location_id"
    t.string   "name"
    t.boolean  "is_location", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "outlets", ["location_id", "name"], name: "by_location_outlet", using: :btree

  create_table "periodical_sales", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "periodID"
    t.string   "p_name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "sale_amount"
    t.integer  "no_of_transaction"
    t.float    "per_of_sale"
    t.float    "avg_sale_per_transaction"
    t.string   "period_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "remark_masters", force: true do |t|
    t.integer  "location_id"
    t.string   "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "remark_masters", ["location_id", "remarks"], name: "by_loc_remarks", unique: true, using: :btree

  create_table "sale_analyses", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.float    "in_cash"
    t.float    "in_credit_card"
    t.float    "in_cheque"
    t.float    "in_sodexho"
    t.float    "in_manager"
    t.float    "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.string   "co_name"
    t.integer  "kot_print"
    t.integer  "settlement_print"
    t.string   "cut_file"
    t.integer  "by_waiter"
    t.integer  "by_steward"
    t.integer  "bill_no_cont"
    t.integer  "kot_no_auto"
    t.integer  "bill_print_dos"
    t.integer  "bill_width"
    t.integer  "bottom_margin"
    t.integer  "bill_copies"
    t.string   "remarks_item"
    t.integer  "cancel_kot_print"
    t.integer  "pax"
    t.integer  "bar_food_bill_no_sep"
    t.integer  "kot_copies"
    t.string   "rate_print_in_bill"
    t.integer  "local_kot_print"
    t.integer  "single_lane_kot_print"
    t.string   "cash_drawer_file"
    t.string   "multiple_outlet"
    t.string   "hotel_link"
    t.string   "bill_page"
    t.string   "kotprint"
    t.string   "user_print"
    t.string   "save_kot_same_page"
    t.boolean  "dsn"
    t.string   "local_comp"
    t.string   "remote_comp"
    t.integer  "kot_print_group_blank"
    t.integer  "waiter_fixed"
    t.integer  "first_qty_then_code"
    t.string   "menu_outlet_wise"
    t.integer  "waiter_common_for_outlet"
    t.integer  "warning_msg_date"
    t.integer  "user_common_for_outlet"
    t.integer  "delivery_settlement_page"
    t.string   "multiple_location"
    t.boolean  "auto_email"
    t.string   "sender_email"
    t.string   "receiver_email"
    t.boolean  "save_bill_in_text"
    t.string   "file_path"
    t.boolean  "combo_offer_for_reverse"
    t.string   "logo_print"
    t.string   "time_print"
    t.boolean  "bill_no_separate_outlet"
    t.boolean  "settlement_together"
    t.boolean  "update_inv"
    t.string   "bar_alias"
    t.string   "food_alias"
    t.boolean  "touch_screen"
    t.boolean  "co_name_print"
    t.boolean  "add_print_kot"
    t.boolean  "establishment_charge"
    t.string   "establishment_on"
    t.float    "establishment_perc"
    t.boolean  "stub_print"
    t.boolean  "amount_in_comp_bill"
    t.boolean  "user_print_kot"
    t.boolean  "time_print_kot"
    t.boolean  "save_time"
    t.boolean  "mrp_and_est_show_inbarbill"
    t.integer  "pp_for_pc"
    t.integer  "pop_for_mic"
    t.boolean  "insa_to_deduct_tax2_inc"
    t.boolean  "win_bill_line2"
    t.boolean  "card_swip"
    t.string   "co_no"
    t.string   "location_no"
    t.string   "bill_win_print_type"
    t.integer  "mrp_bill_type"
    t.string   "port_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["location_id", "outlet_id"], name: "by_location_outlet_settings", unique: true, using: :btree

  create_table "staff_menu_settings", force: true do |t|
    t.integer  "staff_id"
    t.string   "menu"
    t.boolean  "is_visible", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "staff_menu_settings", ["staff_id", "menu"], name: "by_staff_menu", unique: true, using: :btree

  create_table "staff_sub_menu_settings", force: true do |t|
    t.integer  "staff_id"
    t.string   "sub_menu"
    t.boolean  "is_add",     default: true
    t.boolean  "is_find",    default: true
    t.boolean  "is_edit",    default: true
    t.boolean  "is_delete",  default: true
    t.boolean  "is_visible", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "staff_sub_menu_settings", ["staff_id", "sub_menu"], name: "by_staff_sub_menu", unique: true, using: :btree

  create_table "staffs", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.string   "name",               default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "staffs", ["location_id", "name"], name: "by_location_staff", unique: true, using: :btree

  create_table "states", force: true do |t|
    t.string   "s_name"
    t.string   "s_abbr"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["country_id", "s_name", "s_abbr"], name: "index_states_on_country_id_and_s_name_and_s_abbr", unique: true, using: :btree

  create_table "stewards", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "s_no"
    t.string   "s_name"
    t.float    "sale_ratio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stewards", ["location_id", "s_no", "s_name"], name: "by_location_steward", using: :btree
  add_index "stewards", ["outlet_id"], name: "index_stewards_on_outlet_id", using: :btree
  add_index "stewards", ["s_name"], name: "index_stewards_on_s_name", using: :btree

  create_table "table_sections", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.string   "section"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "table_sections", ["location_id", "outlet_id", "section"], name: "by_location_tbl_sec", unique: true, using: :btree
  add_index "table_sections", ["outlet_id"], name: "index_table_sections_on_outlet_id", using: :btree
  add_index "table_sections", ["section"], name: "index_table_sections_on_section", using: :btree

  create_table "tables", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.string   "t_name"
    t.integer  "max_pax"
    t.integer  "position"
    t.integer  "table_section_id"
    t.boolean  "inUse",            default: false
    t.string   "tax3app"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tables", ["location_id", "t_name", "position"], name: "by_location_table", unique: true, using: :btree

  create_table "taxes", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "tax_auto_id"
    t.float    "tax1_per"
    t.string   "tax1_name",              default: ""
    t.float    "tax2_per",               default: 0.0
    t.string   "tax2_name",              default: ""
    t.float    "tax3_per",               default: 0.0
    t.string   "tax3_name",              default: ""
    t.float    "tax4_per",               default: 0.0
    t.string   "tax4_name",              default: ""
    t.float    "tax5_per",               default: 0.0
    t.string   "tax5_name",              default: ""
    t.string   "tax_cal_after_dis"
    t.string   "rate_incd_of_stax"
    t.boolean  "service_tax_applicable"
    t.float    "service_tax"
    t.float    "edu_tax"
    t.float    "hs_edu_tax"
    t.float    "abatement"
    t.boolean  "rate_incd_of_tax1"
    t.boolean  "show_tax1_incl_in_bill"
    t.boolean  "tax1_cal_last"
    t.boolean  "st_on_tax4_applicable"
    t.float    "st_per_on_tax4",         default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taxes", ["location_id", "tax_auto_id"], name: "by_location_tax", unique: true, using: :btree
  add_index "taxes", ["outlet_id"], name: "index_taxes_on_outlet_id", using: :btree

  create_table "void_bills", force: true do |t|
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "bill_no"
    t.string   "table_no"
    t.datetime "bill_date"
    t.string   "bill_type"
    t.datetime "bill_time"
    t.integer  "waiter_id"
    t.float    "dis_per"
    t.float    "discount"
    t.float    "s_tax"
    t.float    "total"
    t.string   "pay_type"
    t.integer  "staff_id"
    t.string   "staff_name"
    t.integer  "modified_by"
    t.string   "modified_name"
    t.datetime "modified_date"
    t.string   "modified_time"
    t.integer  "cover"
    t.text     "comment"
    t.integer  "customer_id"
    t.string   "customer_name"
    t.string   "cc_name"
    t.datetime "settle_time"
    t.text     "remarks"
    t.string   "step",              default: "started"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "void_bills", ["bill_date"], name: "index_void_bills_on_bill_date", using: :btree
  add_index "void_bills", ["bill_no"], name: "index_void_bills_on_bill_no", using: :btree
  add_index "void_bills", ["bill_type"], name: "index_void_bills_on_bill_type", using: :btree
  add_index "void_bills", ["customer_id"], name: "index_void_bills_on_customer_id", using: :btree
  add_index "void_bills", ["customer_name"], name: "index_void_bills_on_customer_name", using: :btree
  add_index "void_bills", ["financial_year_id"], name: "index_void_bills_on_financial_year_id", using: :btree
  add_index "void_bills", ["location_id", "outlet_id", "bill_no", "bill_date", "bill_type", "financial_year_id"], name: "by_location_outlet_bill_void", unique: true, using: :btree
  add_index "void_bills", ["outlet_id"], name: "index_void_bills_on_outlet_id", using: :btree
  add_index "void_bills", ["waiter_id"], name: "index_void_bills_on_waiter_id", using: :btree

  create_table "waiters", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "w_no"
    t.string   "w_name"
    t.string   "service_charge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "waiters", ["location_id", "w_no"], name: "by_location_waiter", unique: true, using: :btree
  add_index "waiters", ["outlet_id"], name: "index_waiters_on_outlet_id", using: :btree
  add_index "waiters", ["w_name"], name: "index_waiters_on_w_name", using: :btree

end
