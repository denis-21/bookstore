class Rating < ActiveRecord::Base

  validates :review, :rating, presence: true
  validates :rating, numericality: { only_integer: true }
  validates :rating, inclusion: { in: 1..5 }

  belongs_to :user
  belongs_to :book

  scope :approved, -> { where(status: :true) }
end
