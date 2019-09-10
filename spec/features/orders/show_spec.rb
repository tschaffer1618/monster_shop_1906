require 'rails_helper'

RSpec.describe "User Profile Order Page" do
  before :each do
    @user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    merchant_1 = create(:merchant)

    @item_1 = merchant_1.items.create!(attributes_for(:item))
    @item_2 = merchant_1.items.create!(attributes_for(:item))

    @order_1 = create(:order, status: 'pending')
    @order_2 = create(:order, status: 'packaged')
    @item_order_1 = @user.item_orders.create!(order: @order_1, item: @item_1, quantity: 1, price: @item_1.price)
    @item_order_2 = @user.item_orders.create!(order: @order_1, item: @item_2, quantity: 3, price: @item_2.price)
  end

  it "I can cancel the order only if it's pending" do
    visit "/orders/#{@order_1.id}"

    expect(page).to have_link("Cancel Order")

    click_link "Cancel Order"

    expect(current_path).to eq(profile_path)

    expect(page).to have_content("Your order has been cancelled")

    visit "/orders/#{@order_1.id}"

    expect(page).to have_content("Unfulfilled")

    expect(page).to have_content("cancelled")
  end
end
