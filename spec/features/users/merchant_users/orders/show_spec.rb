require 'rails_helper'

RSpec.describe "Merchant Order Show Page" do
  before :each do
    @regular_user_1 = create(:user)
    @address_1 = @regular_user_1.addresses.create(name: @regular_user_1.name, street_address: @regular_user_1.address, city: @regular_user_1.city, state: @regular_user_1.state, zipcode: @regular_user_1.zipcode, nickname: 'home')

    @merchant_shop_1 = create(:merchant, name: "Merchant Shop 1")
      @item_1 = @merchant_shop_1.items.create(attributes_for(:item, name: "Item 1", inventory: 10))
      @item_2 = @merchant_shop_1.items.create(attributes_for(:item, name: "Item 2", inventory: 15))
      @item_5 = @merchant_shop_1.items.create(attributes_for(:item, name: "Item 5", inventory: 0))

    @merchant_shop_2 = create(:merchant, name: "Merchant Shop 2")
      @item_3 = @merchant_shop_2.items.create(attributes_for(:item, name: "Item 3", inventory: 20))
      @item_4 = @merchant_shop_2.items.create(attributes_for(:item, name: "Item 4", inventory: 10))

    @order_1 = @address_1.orders.create
      @item_order_1 = @order_1.item_orders.create(item: @item_1, quantity: 2, price: @item_1.price, fulfilled?: false)
      @item_order_2 = @order_1.item_orders.create(item: @item_2, quantity: 8, price: @item_2.price, fulfilled?: false)
      @item_order_3 = @order_1.item_orders.create(item: @item_3, quantity: 10, price: @item_3.price, fulfilled?: false)

    @order_2 = @address_1.orders.create
      @item_order_4 = @order_2.item_orders.create(item: @item_2, quantity: 100, price: @item_2.price, fulfilled?: false)

    @order_3 = @address_1.orders.create
      @item_order_5 = @order_3.item_orders.create(item: @item_4, quantity: 18, price: @item_4.price, fulfilled?: false)

    @order_4 = @address_1.orders.create
      @item_order_6 = @order_4.item_orders.create(item: @item_5, quantity: 15, price: @item_5.price, fulfilled?: false)

    @merchant_admin_1 = create(:user, role: 2, merchant: @merchant_shop_1)
    @merchant_employee_1 = create(:user, role: 1, merchant: @merchant_shop_1)
  end

  it 'merchant user can click on an order link from the dashboard' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin_1)

    visit merchant_user_path


    click_link("Order ##{@order_1.id}")

    expect(current_path).to eq(merchant_order_path(@order_1))
  end

  it 'can only show details about the order pertaining to that merchant' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin_1)

    visit merchant_order_path(@order_1)

    within "#shipping-address" do
      expect(page).to have_content(@order_1.address.name)
      expect(page).to have_content(@order_1.address.street_address)
      expect(page).to have_content(@order_1.address.city)
      expect(page).to have_content(@order_1.address.state)
      expect(page).to have_content(@order_1.address.zipcode)
    end

    within "#item-orders-#{@item_order_1.id}" do
      expect(page).to have_content(@item_order_1.item.name)
      expect(page).to have_link("Item 1")
      expect(page).to have_css("img[src*='#{@item_order_1.item.image}']")
      expect(page).to have_content(@item_order_1.item.price)
    end

    within "#item-orders-#{@item_order_2.id}" do
      expect(page).to have_content(@item_order_2.item.name)
      expect(page).to have_link("Item 2")
      expect(page).to have_css("img[src*='#{@item_order_2.item.image}']")
      expect(page).to have_content(@item_order_2.item.price)
    end
  end

  it 'cannot show details pertaining to other merchant' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin_1)

    visit merchant_order_path(@order_1)

    expect(page).not_to have_css("#item_orders-#{@item_order_3.id}")
    expect(page).not_to have_content(@item_order_3.item.name)

    expect(page).not_to have_css("#item_orders-#{@item_order_4.id}")
  end

  it 'merchant user cannot see the shipping information if not their order' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin_1)

    visit merchant_order_path(@order_3)

    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end

  it 'Merchant user can fulfill order if items in stock' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin_1)

    visit merchant_order_path(@order_1)

    within "#item-orders-#{@item_order_1.id}" do
      click_link("Fulfill Item")
    end

    expect(current_path).to eq(merchant_order_path(@order_1))

    within "#item-orders-#{@item_order_1.id}" do
      expect(page).to have_content("Fulfilled")
    end

    within "#item-orders-#{@item_order_2.id}" do
      expect(page).to have_content("Fulfill Item")
    end

    expect(page).to have_content("Item order ##{@item_order_1.id} has been fulfilled")

    within "#item-orders-#{@item_order_1.id}" do
      expect(page).to have_content("8")
    end
  end

  it 'Merchant user cannot fulfill order if item quantity less than stock' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin_1)

    visit merchant_order_path(@order_2)

    within "#item-orders-#{@item_order_4.id}" do
      expect(page).to_not have_link("Fulfill Item")
      expect(page).to have_content("Cannot fulfill. Only #{@item_order_4.item.inventory} remaining")
    end

    visit merchant_order_path(@order_4)

    within "#item-orders-#{@item_order_6.id}" do
      expect(page).to_not have_link("Fulfill Item")
      expect(page).to have_content("Cannot fulfill. There are no #{@item_order_6.item.name} items remaining")
    end
  end
end
