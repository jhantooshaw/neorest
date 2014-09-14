class CreatePeriodicalSales < ActiveRecord::Migration
  def change
    create_table :periodical_sales do |t|
      t.references       :client
      t.references       :financial_year
      t.references       :location
      t.references       :outlet      
      t.integer          :periodID
      t.string           :p_name
      t.datetime         :start_time
      t.datetime         :end_time
      t.float            :sale_amount
      t.integer          :no_of_transaction
      t.float            :per_of_sale
      t.float            :avg_sale_per_transaction
      t.string           :period_group
      t.timestamps
    end
  end
end
