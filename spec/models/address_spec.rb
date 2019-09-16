require 'rails_helper'

describe Address, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :street_address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zipcode }
    it { should validate_presence_of :nickname }
  end

  describe "relationships" do
    it {should have_many :orders}
    it {should belong_to :user}
  end

  describe 'instance methods' do
    before(:each) do
      @user = create(:user)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @address_1 = @user.addresses.create(name: @user.name, street_address: @user.address, city: @user.city, state: @user.state, zipcode: @user.zipcode, nickname: 'home')
      @address_2 = @user.addresses.create(name: 'Rex Dinosaur', street_address: '12 Toy Lane', city: 'Chicago', state: 'IL', zipcode: '75405', nickname: 'rex house')

      @order_1 = @address_1.orders.create(status: 0, user: @user)
        @item_order_1 = @order_1.item_orders.create(item: @tire, price: @tire.price, quantity: 2, fulfilled?: true)
        @item_order_2 = @order_1.item_orders.create(item: @pull_toy, price: @pull_toy.price, quantity: 3, fulfilled?: true)

      @order_2 = @address_1.orders.create(status: 1, user: @user)
        @item_order_3 = @order_2.item_orders.create(item: @tire, quantity: 100, price: @tire.price, fulfilled?: true)

      @order_3 = @address_2.orders.create(status: 3, user: @user)
        @item_order_4 = @order_3.item_orders.create(item: @pull_toy, quantity: 18, price: @pull_toy.price, fulfilled?: true)
    end

    it 'shipped_to?' do
      expect(@address_1.shipped_to?).to eq false
      expect(@address_2.shipped_to?).to eq false

      order_4 = @address_2.orders.create(status: 2, user: @user)
        item_order_5 = order_4.item_orders.create(item: @tire, quantity: 15, price: @tire.price, fulfilled?: true)

      expect(@address_2.shipped_to?).to eq true
    end
  end
end
