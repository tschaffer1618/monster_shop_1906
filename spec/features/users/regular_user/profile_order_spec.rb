require 'rails_helper'

RSpec.describe "User Profile Order Page" do
  before :each do
    @user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    merchant_1 = create(:merchant)

    @item_1 = merchant_1.items.create!(attributes_for(:item))
    @item_2 = merchant_1.items.create!(attributes_for(:item))

    @order_1 = create(:order)
    @item_order_1 = @user.item_orders.create!(order: @order_1, item: @item_1, quantity: 1, price: @item_1.price)
    @item_order_2 = @user.item_orders.create!(order: @order_1, item: @item_2, quantity: 3, price: @item_2.price)
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

    fill_in :name, with: "Bert"
    fill_in :address, with: "123 Sesame St"
    fill_in :city, with: "New York"
    fill_in :state, with: "NY"
    fill_in :zip, with: 10022

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
      expect(page).to have_link(@order_1.id)
      expect(page).to have_content(@item_1.name)
      expect(page).to have_css("#thumbnail-#{@item_order_1.id}")
      expect(page).to have_content(@item_1.merchant.name)
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content(@item_order_1.quantity)
      expect(page).to have_content(@item_order_1.subtotal)
      expect(page).to have_content(@order_1.name)
      expect(page).to have_content(@order_1.address)
      expect(page).to have_content(@order_1.city)
      expect(page).to have_content(@order_1.state)
      expect(page).to have_content(@order_1.zip)
      expect(page).to have_content(@item_order_1.created_at)
      expect(page).to have_content(@item_order_1.updated_at)
      expect(page).to have_content(@item_order_1.order.status)

      click_link(@order_1.id)
    end

    expect(current_path).to eq(order_path(@order_1.id))

    visit "/profile/orders"

    within "#item-order-#{@item_order_2.id}" do
      expect(page).to have_link(@order_1.id)
      expect(page).to have_content(@item_2.name)
      expect(page).to have_css("#thumbnail-#{@item_order_2.id}")
      expect(page).to have_content(@item_2.merchant.name)
      expect(page).to have_content(@item_2.price)
      expect(page).to have_content(@item_order_2.quantity)
      expect(page).to have_content(@item_order_2.subtotal)
      expect(page).to have_content("#{@order_1.name} #{@order_1.address} #{@order_1.city}, #{@order_1.state} #{@order_1.zip}")
      expect(page).to have_content(@item_order_2.created_at)
      expect(page).to have_content(@item_order_2.updated_at)
      expect(page).to have_content(@item_order_2.order.status)
    end

    within "#order-stats-#{@order_1.id}" do
      expect(page).to have_content(4)
      expect(page).to have_content("$#{@order_1.grandtotal}")
    end
  end

  # it "when I visit an order's show page, I see a button/link to cancel the order only if the order is still pending. When I click the cancel button for an order, each row in the order items table is given a status of 'unfulfilled', the order itself is given a status of 'cancelled', any item quantities in the order that were previously fulfilled have their quantities returned to their merchant's inventory for that item, I am returned to my profile page, I see a flash message telling me the order is now cancelled, and I see that this order now has an updated status of 'cancelled'" do
  #   visit profile_orders_path
  #
  #   expect(page).to have_link "Cancel Order"
  #
  #
  #   within "#item-order-#{@item_order_1.id}" do
  #     click_link "Cancel Order"
  #     expect(page).to have_content("Unfulfilled")
  #     expect(page).to have_content("Cancelled")
  #     expect(@item_order_1.quantity).to eq(0)
  #     #merchant quantities returned to merchant's inventory
  #   end
  #
  #   expect(current_path).to eq(profile_path)
  #   expect(page).to have_content("Order ##{@order_1.id} has been cancelled.")
  #
  # end
end
