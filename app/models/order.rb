class Order < ApplicationRecord
  validates_presence_of :status

  belongs_to :address
  has_many :item_orders
  has_many :items, through: :item_orders
  has_many :merchants, through: :items

  enum status: [:packaged, :pending, :shipped, :cancelled]

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items
    item_orders.sum(:quantity)
  end

  def to_s
    "#{self.address.name}
    #{self.address.street_address}
    #{self.address.city}, #{self.address.state}
    #{self.address.zipcode}
    "
  end

  def update_status
   self.update(status: 'packaged') if item_orders.all? { |item_order| item_order.fulfilled?}
   self.save
  end

  def self.sort_by_status
    order(status: :asc)
  end

  def cancel_order
    self.item_orders.each do |item_order|
      if item_order.fulfilled?
        item_order.item.increase_inventory(item_order)
      end
      item_order.update(fulfilled?: false)
      item_order.save
      item = Item.find(item_order.item_id)
      item.save
    end
  end
end
