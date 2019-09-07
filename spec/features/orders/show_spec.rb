require 'rails_helper'

RSpec.describe "User Profile Order Page" do
  before :each do
    @user = create(:user)

    @merchant_1 = create(:merchant)

    @item_1 = @merchant_1.items.create!(attributes_for(:item, inventory: 10))
    @item_2 = @merchant_1.items.create!(attributes_for(:item, inventory: 10))

    @order_1 = create(:order, status: 'pending')
    @order_2 = create(:order, status: 'packaged')

    @item_order_1 = @user.item_orders.create!(order: @order_1, item: @item_1, quantity: 1, price: @item_1.price)
    @item_order_2 = @user.item_orders.create!(order: @order_1, item: @item_2, quantity: 3, price: @item_2.price)
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
