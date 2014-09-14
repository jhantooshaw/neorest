class CreateFinancialYears < ActiveRecord::Migration
  def change
    create_table :financial_years do |t|
      t.string        :name,    null: false, default: ""
      t.date          :start_date
      t.date          :end_date
      t.references    :client
      t.timestamps
    end     
    add_index :financial_years, [:client_id, :name, :start_date, :end_date], name: 'by_client_fin_year', unique: true
  end
end