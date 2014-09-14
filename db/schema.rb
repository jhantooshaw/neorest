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
    t.integer  "user_id"
    t.string   "user_name"
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

  create_table "bill_detail_backups", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
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
    t.decimal  "rate",              precision: 10, scale: 0
    t.integer  "qty"
    t.decimal  "amount",            precision: 10, scale: 0
    t.decimal  "excise_amount",     precision: 10, scale: 0
    t.string   "taxable"
    t.string   "excisable"
    t.string   "discountable"
    t.boolean  "quety"
    t.decimal  "tax",               precision: 10, scale: 0
    t.decimal  "total",             precision: 10, scale: 0
    t.string   "canceled"
    t.string   "under"
    t.integer  "add_qty"
    t.string   "kot"
    t.datetime "kot_time"
    t.decimal  "mrp",               precision: 10, scale: 0
    t.decimal  "s_charge",          precision: 10, scale: 0
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
    t.decimal  "dis_per",                precision: 10, scale: 0
    t.decimal  "discount",               precision: 10, scale: 0
    t.integer  "tax_id"
    t.decimal  "service_tax_per",        precision: 10, scale: 0
    t.decimal  "service_tax",            precision: 10, scale: 0
    t.decimal  "edu_tax_per",            precision: 10, scale: 0
    t.decimal  "edu_tax",                precision: 10, scale: 0
    t.decimal  "hs_edu_tax_per",         precision: 10, scale: 0
    t.decimal  "hs_edu_tax",             precision: 10, scale: 0
    t.string   "tax1"
    t.string   "tax1_per"
    t.decimal  "tax1_amount",            precision: 10, scale: 0
    t.string   "tax2"
    t.string   "tax2_per"
    t.decimal  "tax2_amount",            precision: 10, scale: 0
    t.string   "tax3"
    t.string   "tax3_per"
    t.decimal  "tax3_amount",            precision: 10, scale: 0
    t.string   "tax4"
    t.string   "tax4_per"
    t.decimal  "tax4_amount",            precision: 10, scale: 0
    t.string   "tax5"
    t.string   "tax5_per"
    t.decimal  "tax5_amount",            precision: 10, scale: 0
    t.decimal  "s_tax",                  precision: 10, scale: 0
    t.decimal  "excise_amount",          precision: 10, scale: 0
    t.decimal  "round_off",              precision: 10, scale: 0
    t.decimal  "net_amount",             precision: 10, scale: 0
    t.decimal  "total_amount",           precision: 10, scale: 0
    t.decimal  "sub_total_amount",       precision: 10, scale: 0
    t.decimal  "taxable_amount",         precision: 10, scale: 0
    t.decimal  "non_taxable_amount",     precision: 10, scale: 0
    t.decimal  "exciseable_amount",      precision: 10, scale: 0
    t.string   "pay_type"
    t.integer  "user_id"
    t.string   "user_name"
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
    t.decimal  "actual_amount",          precision: 10, scale: 0
    t.decimal  "food_amount",            precision: 10, scale: 0
    t.decimal  "food_tax",               precision: 10, scale: 0
    t.decimal  "food_total",             precision: 10, scale: 0
    t.decimal  "beverage_amount",        precision: 10, scale: 0
    t.decimal  "beverage_tax",           precision: 10, scale: 0
    t.decimal  "beverage_total",         precision: 10, scale: 0
    t.decimal  "wine_amount",            precision: 10, scale: 0
    t.decimal  "beer_amount",            precision: 10, scale: 0
    t.decimal  "cal_sub_total",          precision: 10, scale: 0
    t.decimal  "tips",                   precision: 10, scale: 0
    t.decimal  "grand_total",            precision: 10, scale: 0
    t.datetime "settle_time"
    t.integer  "no_of_print"
    t.decimal  "pay_changed",            precision: 10, scale: 0
    t.decimal  "dis_food",               precision: 10, scale: 0
    t.decimal  "dis_liquer",             precision: 10, scale: 0
    t.decimal  "dis_both",               precision: 10, scale: 0
    t.string   "room_no"
    t.datetime "hotel_date"
    t.string   "banquet"
    t.datetime "out_time"
    t.string   "linked_financial_year"
    t.boolean  "rate_incd_of_tax1"
    t.string   "tax_cal_after_dis"
    t.string   "rate_incd_of_stax"
    t.boolean  "service_tax_applicable"
    t.decimal  "abatement",              precision: 10, scale: 0
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
    t.integer  "user_id"
    t.string   "user_name"
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
    t.string   "pay_changed"
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
  add_index "bill_master_backups", ["location_id", "outlet_id", "bill_no", "bill_date", "bill_type", "financial_year_id"], name: "by_location_outlet_bill", unique: true, using: :btree
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

  create_table "combo_packages", force: true do |t|
    t.integer  "location_id"
    t.string   "name"
    t.boolean  "is_active",         default: false
    t.boolean  "linked_happy_hour", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "user_id"
    t.string   "user_name"
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

  create_table "countries", force: true do |t|
    t.string   "c_name"
    t.string   "c_abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", force: true do |t|
    t.integer  "location_id"
    t.string   "cc_name"
    t.decimal  "commision_amount", precision: 10, scale: 0, default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.decimal  "dis_per",              precision: 10, scale: 0
    t.datetime "order_date"
    t.text     "remarks"
    t.string   "membership_no_manual"
    t.string   "card_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deleted_item_details", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "bill_no"
    t.datetime "bill_date"
    t.string   "bill_type"
    t.integer  "item_id"
    t.string   "table_no"
    t.string   "kot_no"
    t.decimal  "rate",              precision: 10, scale: 0
    t.integer  "qty"
    t.decimal  "amount",            precision: 10, scale: 0
    t.datetime "deleted_time"
    t.text     "remarks"
    t.decimal  "mrp",               precision: 10, scale: 0
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

  create_table "financial_years_locations", id: false, force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "item_groups", force: true do |t|
    t.integer  "location_id"
    t.string   "ig_name"
    t.string   "ig_tag"
    t.decimal  "order_kot",   precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_groups_kot_prints", force: true do |t|
    t.integer  "location_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_sub_groups", force: true do |t|
    t.integer  "location_id"
    t.string   "isg_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "item_group_id"
    t.integer  "item_sub_group_id"
    t.string   "code_no"
    t.string   "description"
    t.decimal  "rate",                 precision: 10, scale: 0
    t.decimal  "rate2",                precision: 10, scale: 0
    t.decimal  "mrp",                  precision: 10, scale: 0
    t.boolean  "is_taxable",                                    default: true
    t.string   "excisable"
    t.string   "discountable"
    t.string   "disable"
    t.decimal  "dsale",                precision: 10, scale: 0
    t.decimal  "svalue",               precision: 10, scale: 0
    t.decimal  "canceled_qty",         precision: 10, scale: 0
    t.decimal  "canceled_amount",      precision: 10, scale: 0
    t.string   "under"
    t.integer  "item_groups_kot_id"
    t.decimal  "service_charge",       precision: 10, scale: 0
    t.string   "event"
    t.string   "i_alias"
    t.string   "kot_printer"
    t.integer  "kot_printer_position"
    t.integer  "bill_group_id"
    t.boolean  "is_special",                                    default: false
    t.boolean  "is_active",                                     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cost",                 precision: 10, scale: 0
    t.boolean  "open_item"
  end

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

  create_table "outlets", force: true do |t|
    t.integer  "location_id"
    t.string   "name"
    t.boolean  "is_location", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "periodical_sales", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "periodID"
    t.string   "p_name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal  "sale_amount",              precision: 10, scale: 0
    t.integer  "no_of_transaction"
    t.decimal  "per_of_sale",              precision: 10, scale: 0
    t.decimal  "avg_sale_per_transaction", precision: 10, scale: 0
    t.string   "period_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "remark_masters", force: true do |t|
    t.integer  "client_id"
    t.string   "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
  end

  create_table "sale_analyses", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.decimal  "in_cash",           precision: 10, scale: 0
    t.decimal  "in_credit_card",    precision: 10, scale: 0
    t.decimal  "in_cheque",         precision: 10, scale: 0
    t.decimal  "in_sodexho",        precision: 10, scale: 0
    t.decimal  "in_manager",        precision: 10, scale: 0
    t.decimal  "total",             precision: 10, scale: 0
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
    t.string   "bill_no_separate_outlet"
    t.boolean  "settlement_together"
    t.boolean  "update_inv"
    t.string   "bar_alias"
    t.string   "food_alias"
    t.boolean  "touch_screen"
    t.boolean  "co_name_print"
    t.boolean  "add_print_kot"
    t.boolean  "establishment_charge"
    t.string   "establishment_on"
    t.decimal  "establishment_perc",         precision: 10, scale: 0
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

  create_table "stewards", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "s_no"
    t.string   "s_name"
    t.decimal  "sale_ratio",        precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "table_sections", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.string   "section"
    t.decimal  "amount",            precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tables", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.string   "t_name"
    t.integer  "max_pax"
    t.integer  "position"
    t.integer  "table_section_id"
    t.boolean  "inUse",             default: true
    t.string   "tax3app"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taxes", force: true do |t|
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "tax_auto_id"
    t.decimal  "tax1_per",               precision: 10, scale: 0
    t.string   "tax1_name"
    t.decimal  "tax2_per",               precision: 10, scale: 0
    t.string   "tax2_name"
    t.decimal  "tax3_per",               precision: 10, scale: 0
    t.string   "tax3_name"
    t.decimal  "tax4_per",               precision: 10, scale: 0
    t.string   "tax4_name"
    t.decimal  "tax5_per",               precision: 10, scale: 0
    t.string   "tax5_name"
    t.string   "tax_cal_after_dis"
    t.string   "rate_incd_of_stax"
    t.boolean  "service_tax_applicable"
    t.decimal  "service_tax",            precision: 10, scale: 0
    t.decimal  "edu_tax",                precision: 10, scale: 0
    t.decimal  "hs_edu_tax",             precision: 10, scale: 0
    t.decimal  "abatement",              precision: 10, scale: 0
    t.boolean  "rate_incd_of_tax1"
    t.boolean  "show_tax1_incl_in_bill"
    t.boolean  "tax1_cal_last"
    t.boolean  "st_on_tax4_applicable"
    t.boolean  "st_per_on_tax4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "user_id"
    t.string   "user_name"
    t.integer  "modified_by"
    t.string   "modified_name"
    t.datetime "modified_date"
    t.string   "modified_time",     limit: 2255
    t.integer  "cover"
    t.text     "comment"
    t.integer  "customer_id"
    t.string   "customer_name"
    t.string   "cc_name"
    t.datetime "settle_time"
    t.text     "remarks"
    t.string   "step",                           default: "started"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "waiters", force: true do |t|
    t.integer  "client_id"
    t.integer  "financial_year_id"
    t.integer  "location_id"
    t.integer  "outlet_id"
    t.integer  "w_no"
    t.string   "w_name"
    t.string   "service_charge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
