class CreateSaleAnalyses < ActiveRecord::Migration
  def change
    create_table :sale_analyses do |t|
      t.references       :client
      t.references       :financial_year
      t.references       :location
      t.references       :outlet      
      t.float            :in_cash
      t.float            :in_credit_card
      t.float            :in_cheque
      t.float            :in_sodexho
      t.float            :in_manager
      t.float            :total
      t.timestamps
    end
  end
end
