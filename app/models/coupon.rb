class Coupon < ActiveRecord::Base
  validates :name, :discount, :expires_at, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  has_many :order

  scope :active, ->  { where("expires_at >=?", Date.today) }
end
