class Address < ActiveRecord::Base

  validates :first_name, :last_name,:address,:phone, :city, :country, :zipcode,  presence: true
  validates :zipcode, length: { is: 5 }
  validates :phone, length: { minimum: 5, maximum: 12 }

  has_one :order
  belongs_to :user

end
