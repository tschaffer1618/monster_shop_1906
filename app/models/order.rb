class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  has_many :item_orders
  has_many :items, through: :item_orders
  has_many :merchants, through: :item
  has_many :users, through: :item_orders

  enum status: [:pending, :packaged, :shipped, :cancelled]

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items
    item_orders.sum(:quantity)
  end

  def to_s
    "#{self.name}
    #{self.address}
    #{self.city}, #{self.state}
    #{self.zip}
    "
  end
end
