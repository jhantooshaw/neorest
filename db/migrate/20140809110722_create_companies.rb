class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.references       :client
      t.string           :name
      t.string           :address1
      t.string           :address2
      t.string           :address3
      t.string           :address4
      t.string           :address5
      t.string           :phone
      t.string           :other
      t.date             :start_date
      t.date             :end_date
      t.timestamps
    end
    add_index :companies, [:client_id, :name, :address1], name: 'by_client_company', unique: true
    add_index :companies, :name
  end
end