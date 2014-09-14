class PeriodicalSale < ActiveRecord::Base
  belongs_to   :client
  belongs_to   :financial_year
  belongs_to   :location
  
  
end
