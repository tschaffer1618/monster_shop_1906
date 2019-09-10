class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity
  validates :fulfilled?, inclusion: {:in => [true, false]}
  belongs_to :item
  belongs_to :order
  belongs_to :user
  has_many :merchants, through: :item

  def subtotal
    price * quantity
  end

  def self.total_quantity_per_order(order_id)
    where(order_id: order_id).sum(:quantity)
  end

  def self.grandtotal_per_order(order_id)
    find_by(order_id: order_id).order.grandtotal
  end

  def instock?
    self.item.inventory >= self.quantity
  end

  def update_status
    self.update(fulfilled?: true)
  end
end
