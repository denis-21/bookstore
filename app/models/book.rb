class Book < ActiveRecord::Base

    validates :title, :price, :stock, :author, :category,:description, presence: true
    validates :price, numericality: { greater_than_or_equal_to: 0.01 }


    mount_uploader :image, ImageUploader
    paginates_per 12 #paginates counts
    belongs_to :category
    belongs_to :author
    has_and_belongs_to_many :users
    has_many :order_items
    has_many :ratings, dependent: :destroy

    default_scope { order(id: :desc) }
    scope :search, ->(query){ joins(:author).where("books.title ILIKE ? OR concat(authors.first_name,' ',authors.last_name)  ILIKE ?", "%#{query}%", "%#{query}%") }


end
