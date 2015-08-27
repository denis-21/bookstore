class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_and_belongs_to_many :books
  has_many :orders
  has_many :ratings, dependent: :destroy
  has_one :billing_address, class_name: "Address"
  has_one :shipping_address, class_name: "Address"
  has_one :credit_card,dependent: :destroy


  def book_in_wishlist?(book)
    self.books.include?(book)
  end

  def add_to_wishlist(book)
    self.books << book
  end

  def delete_from_wishlist(book)
    self.books.delete book
  end



  def self.facebook_login(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

end
