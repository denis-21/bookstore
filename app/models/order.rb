class Order < ActiveRecord::Base

  validates :state, presence: true


  has_many :order_items,dependent: :destroy
  belongs_to :user
  belongs_to :credit_card
  belongs_to :delivery
  belongs_to :billing_address, class_name: 'Address'
  belongs_to :shipping_address, class_name: 'Address'


  include AASM
  validates :state,
            inclusion: { in: %w(in_progress in_queue in_delivery delivered canceled) }


  aasm column: 'state' do
    state :in_progress, initial: true
    state :in_queue, after_enter: :complete_date
    state :in_delivery
    state :delivered
    state :canceled

    event :submit do
      transitions from: :in_progress, to: :in_queue
    end

    event :ship do
      transitions from: :in_queue, to: :in_delivery
    end

    event :complete  do
      transitions from: :in_delivery, to: :delivered
    end

    event :cancel  do
      transitions from: [:in_progress, :in_queue, :in_delivery], to: :canceled
    end
  end

  def add_item_to_cart (book,quantity)
    quantity = 1 if quantity <= 0
    current_item = self.order_items.where(book: book).first
    if current_item
      current_item.increment!(:quantity,quantity)
    else
      current_item = self.order_items.build(book: book, quantity: quantity)
    end
    current_item.price = current_item.quantity * book.price
    current_item.save
    recount_total_cart_price
  end

  def update_cart (items)
    items.each do |key, value|
      quantity = value[:quantity].to_i <= 0 ? 1 :value[:quantity].to_i
      item = self.order_items.find(key)
      item.quantity = quantity
      item.price = item.quantity * item.book.price
      item.save
    end
    recount_total_cart_price
  end


  def recount_total_cart_price
    reload
    total_price_item = self.order_items.map(&:price).reduce(:+) || 0
    self.total_price = total_price_item
    self.save
  end

  def create_delivery(delivery_id)
    if delivery_id
      self.update(delivery_id: delivery_id)
      true
    else
      false
    end
  end

  def complete_date
    self.completed_at = Time.current
    self.save
  end

end
