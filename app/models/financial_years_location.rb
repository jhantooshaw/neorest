class FinancialYearsLocation < ActiveRecord::Base
  belongs_to :location
  belongs_to :financial_year
  belongs_to :client
end
