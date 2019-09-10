require 'rails_helper'

RSpec.describe "User Profile Order Page" do
  before :each do
    @user = create(:user)

    @merchant_1 = create(:merchant)

    @item_1 = @merchant_1.items.create!(attributes_for(:item))
    @item_2 = @merchant_1.items.create!(attributes_for(:item))

    @order_1 = create(:order, status: 'pending')
    @order_2 = create(:order, status: 'packaged')
    @item_order_1 = @user.item_orders.create!(order: @order_1, item: @item_1, quantity: 1, price: @item_1.price)
    @item_order_2 = @user.item_orders.create!(order: @order_1, item: @item_2, quantity: 3, price: @item_2.price)
  end

  it "I can cancel the order only if it's pending" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit "/orders/#{@order_1.id}"

    expect(page).to have_link("Cancel Order")

    click_link "Cancel Order"

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Your order has been cancelled")

    visit "/orders/#{@order_1.id}"

    expect(page).to have_content("Unfulfilled")
    expect(page).to have_content("cancelled")

    visit "/orders/#{@order_2.id}"

    expect(page).not_to have_link("Cancel Order")
  end

  it "status changes from 'pending' to 'packaged' once all items are fulfilled" do
    michael = User.create!(name: "Michael Scott",
                  address: "1725 Slough Ave",
                  city: "Scranton",
                  state: "PA",
                  zipcode: "18501",
                  email: "michael.s@email.com",
                  password: "WorldBestBoss",
                  role: 2,
                  merchant: @merchant_1)

    visit login_path

    fill_in :email, with: michael.email
    fill_in :password, with: michael.password
    click_on "Submit"

    click_link "Order ##{@order_1.id}"

    within "#item-orders-#{@item_order_1.id}" do
      click_link "Fulfill Item"
      expect(page).to have_content("Fulfilled")
    end

    within "#item-orders-#{@item_order_2.id}" do
      click_link "Fulfill Item"
      expect(page).to have_content("Fulfilled")
    end

    click_link "Logout"

    visit login_path

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Submit"

    click_link "My Orders"

    within "#item-order-#{@item_order_1.id}" do
      expect(page).to have_content("packaged")
    end

  end

end
