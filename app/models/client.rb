require 'role_model'
class Client < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
       
  include RoleModel  
  roles_attribute :roles_mask
  roles :admin, :manager
  
  # attr_accessible :hotel_name, :phone, :mobile, :address, :city, :zipcode, :subdomain, :state_id, :deleted_on, :email, :password, :password_confirmation, :remember_me, :role
       
  has_many      :locations
  has_many      :companies
  has_many      :financial_years
  has_many      :financial_years_locations, dependent: :destroy
  
  
  before_save :ensure_authentication_token
end
