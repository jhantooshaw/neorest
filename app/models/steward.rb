class Steward < ActiveRecord::Base
  belongs_to     :client
  belongs_to    :financial_year
  belongs_to    :location
  belongs_to    :outlet
  has_many      :bill_master_backups
  has_many      :adj_bill_master_backups
  has_many      :comp_bill_master_backups
  
end
