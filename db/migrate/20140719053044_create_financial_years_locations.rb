class CreateFinancialYearsLocations < ActiveRecord::Migration
  def change
    create_table :financial_years_locations, id: false  do |t|
      t.references       :client
      t.references       :financial_year
      t.references       :location
      t.timestamps
    end
    add_index :financial_years_locations, [:client_id, :financial_year_id, :location_id], name: 'by_client_fin_loc', unique: true
  end
end