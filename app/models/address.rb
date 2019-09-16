class Address < ApplicationRecord
  validates_presence_of :name, :street_address, :city, :state, :zipcode, :nickname

  belongs_to :user
  has_many :orders

  def shipped_to?
    !(orders.find_by(status: 'shipped').nil?)
  end
end
