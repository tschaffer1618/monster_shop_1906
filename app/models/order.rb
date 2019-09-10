class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status
  #validates :status, inclusion: {:in => ['pending', 'packaged', 'shipped', 'cancelled']}

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

  # def find_user_name
  #   find_user.name
  # end
  #
  # def find_user
  #   user_id = self.item_orders.distinct.pluck(:user_id).join
  #   user = User.find(user_id)
  # end

  def by_status
    binding.pry
    self.group_by(:status)
  end
end
