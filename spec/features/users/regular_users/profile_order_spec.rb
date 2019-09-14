require 'rails_helper'

RSpec.describe "User Profile Order Page" do
  before :each do
    @user = create(:user)
    @address_1 = @user.addresses.create(name: @user.name, street_address: @user.address, city: @user.city, state: @user.state, zipcode: @user.zipcode, nickname: 'home')

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    merchant_1 = create(:merchant)

    @item_1 = merchant_1.items.create(attributes_for(:item))
    @item_2 = merchant_1.items.create(attributes_for(:item))

    @order_1 = @address_1.orders.create
    @order_2 = @address_1.orders.create(status: 'packaged')
    @item_order_1 = @order_1.item_orders.create(item: @item_1, quantity: 1, price: @item_1.price)
    @item_order_2 = @order_1.item_orders.create(item: @item_2, quantity: 3, price: @item_2.price)
  end

  it "see a link to my orders" do
    visit profile_path

    expect(page).to have_link("My Orders")
    click_link("My Orders")
    expect(current_path).to eq("/profile/orders")
  end

  it "see a flash message confirming my recent order and empty cart" do
    visit item_path(@item_1)
    click_on "Add To Cart"

    visit "/cart"
    click_on "Checkout"

    click_on "Create Order"

    expect(current_path).to eq("/profile/orders")

    expect(page).to have_content("Your order has been created!")

    within 'nav' do
      expect(page).to have_content("Cart: 0")
    end
  end

  it "see a list of my orders and detailed order info" do
    visit "/profile/orders"

    within "#item-order-#{@item_order_1.id}" do
      expect(page).to have_link("#{@order_1.id}")
      expect(page).to have_content(@item_order_1.created_at)
      expect(page).to have_content(@item_order_1.updated_at)
      expect(page).to have_content(@item_order_1.order.status)
    end

    within "#order-stats-#{@order_1.id}" do
      expect(page).to have_content(4)
      expect(page).to have_content("$#{@order_1.grandtotal}")
    end
  end

  it "can click an individual order id and see detailed info" do
    visit "/profile/orders"

    within "#item-order-#{@item_order_1.id}" do
      click_link("#{@order_1.id}")
    end

    expect(current_path).to eq("/profile/orders/#{@order_1.id}")

    within "#item-order-#{@item_order_1.id}" do
      expect(page).to have_link("#{@order_1.id}")
      expect(page).to have_content(@item_1.name)
      expect(page).to have_css("#thumbnail-#{@item_order_1.id}")
      expect(page).to have_content(@item_1.description)
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content(@item_order_1.quantity)
      expect(page).to have_content(@item_order_1.subtotal)
      expect(page).to have_content(@order_1.address.name)
      expect(page).to have_content(@order_1.address.street_address)
      expect(page).to have_content(@order_1.address.city)
      expect(page).to have_content(@order_1.address.state)
      expect(page).to have_content(@order_1.address.zipcode)
      expect(page).to have_content(@item_order_1.created_at)
      expect(page).to have_content(@item_order_1.updated_at)
      expect(page).to have_content(@item_order_1.order.status)
    end
  end

  it "I can cancel the order only if it's pending" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit "/profile/orders/#{@order_1.id}"

    expect(page).to have_link("Cancel Order")

    click_link "Cancel Order"

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Your order has been cancelled")

    visit "/profile/orders/#{@order_1.id}"

    expect(page).to have_content("cancelled")

    visit "/profile/orders/#{@order_2.id}"

    expect(page).not_to have_link("Cancel Order")
  end
end
