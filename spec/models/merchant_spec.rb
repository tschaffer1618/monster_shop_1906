require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many(:item_orders).through(:items)}
    it {should have_many(:orders).through(:item_orders)}
    it {should have_many :users}
  end

  describe 'instance methods' do
    before(:each) do
      @user = create(:user)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @address_1 = @user.addresses.create(name: @user.name, street_address: @user.address, city: @user.city, state: @user.state, zipcode: @user.zipcode, nickname: 'home')
    end

    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      order_1 = @address_1.orders.create
      item_order_1 = order_1.item_orders.create(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      user = create(:user)
      address_1 = user.addresses.create(name: user.name, street_address: user.address, city: 'Denver', state: user.state, zipcode: user.zipcode, nickname: 'home')
      address_2 = user.addresses.create(name: user.name, street_address: user.address, city: 'Hershey', state: user.state, zipcode: user.zipcode, nickname: 'home')
      address_3 = user.addresses.create(name: user.name, street_address: '12 Test Way', city: 'Denver', state: user.state, zipcode: user.zipcode, nickname: 'home')

      order_1 = address_1.orders.create
      order_2 = address_2.orders.create
      order_3 = address_3.orders.create
      order_1.item_orders.create(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities.sort).to eq(["Denver","Hershey"])
    end

    it 'activate_items' do
      merchant = create(:merchant)
      item = merchant.items.create(attributes_for(:item, active?: false))

      expect(item.active?).to be false

      merchant.activate_items

      expect(item.active?).to be true
    end

    it 'deactivate_items' do
      merchant = create(:merchant)
      item = merchant.items.create(attributes_for(:item, active?: true))

      expect(item.active?).to be true

      merchant.deactivate_items

      expect(item.active?).to be false
    end

    it "pending_orders" do
      user = create(:user)
      address_1 = user.addresses.create(name: user.name, street_address: user.address, city: 'Denver', state: user.state, zipcode: user.zipcode, nickname: 'home')
      order_1 = address_1.orders.create(status: 'pending')
      order_2 = address_1.orders.create(status: 'packaged')
      item_order_1 = order_1.item_orders.create(item: @tire, price: @tire.price, quantity: 2)
      expect(@meg.pending_orders).to eq([order_1])
    end
  end
end
