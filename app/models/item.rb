class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :item_orders
  has_many :orders, through: :item_orders
  has_many :users, through: :merchant

  validates_presence_of :name, :description, :price, :inventory
  validates :image, presence: true, allow_blank: true
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than_or_equal_to: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end
end
