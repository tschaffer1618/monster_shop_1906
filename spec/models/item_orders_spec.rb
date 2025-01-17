require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'methods' do
    before(:each) do
      @user = create(:user)
      @merchant_1 = create(:merchant)
      @item_1 = @merchant_1.items.create(attributes_for(:item, inventory: 10, price: 10))
      @item_2 = @merchant_1.items.create(attributes_for(:item, inventory: 4, price: 30))

      @merchant_2 = create(:merchant)
      @item_3 = @merchant_2.items.create(attributes_for(:item, inventory: 20))
      @item_4 = @merchant_2.items.create(attributes_for(:item, inventory: 0))

      @address_1 = @user.addresses.create(name: @user.name, street_address: @user.address, city: @user.city, state: @user.state, zipcode: @user.zipcode, nickname: 'home')
      @address_2 = @user.addresses.create(name: 'Rex Dinosaur', street_address: '12 Toy Lane', city: 'Chicago', state: 'IL', zipcode: '75405', nickname: 'rex house')

      @order_1 = @address_1.orders.create(status: "pending", user: @user)
        @item_order_1 = @order_1.item_orders.create(item: @item_1, quantity: 1, price: @item_1.price, fulfilled?: false)
        @item_order_2 = @order_1.item_orders.create(item: @item_2, quantity: 3, price: @item_2.price, fulfilled?: false)

      @order_2 = @address_2.orders.create(status: "pending", user: @user)
        @item_order_3 = @order_2.item_orders.create(item: @item_3, quantity: 1, price: @item_3.price, fulfilled?: false)
        @item_order_4 = @order_2.item_orders.create(item: @item_2, quantity: 10000, price: @item_2.price, fulfilled?: false)
    end

    describe 'instance methods' do
      it 'subtotal' do
        expect(@item_order_2.subtotal).to eq(90)
      end

      it 'can return true if item is in stock' do
        expect(@item_order_1.instock?).to eq(true)
        expect(@item_order_4.instock?).to eq(false)
      end

      it 'can update status to packaged' do
        @item_order_1.update_status

        expect(@item_order_1.fulfilled?).to eq(true)
      end
    end

    describe 'class methods' do
      it 'total_quantity_per_order' do
        expect(ItemOrder.total_quantity_per_order(@order_1.id)).to eq(4)
      end

      it 'grandtotal_per_order' do
        expect(ItemOrder.grandtotal_per_order(@order_1.id)).to eq(100)
      end

      it 'display_info' do
        info = ItemOrder.display_info(@order_1)

        expect(info.keys.include? @order_1.id).to eq(true)
        expect(info.values.flatten.count).to eq(2)
      end
    end
  end
end
