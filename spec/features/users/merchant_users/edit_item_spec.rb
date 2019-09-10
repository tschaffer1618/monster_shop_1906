require 'rails_helper'

RSpec.describe "Merchant Items Page" do
  describe "As a merchant admin" do
    before :each do
      @shop = create(:merchant)
      @item_1 = @shop.items.create(attributes_for(:item, name: "apple"))
      @item_2 = @shop.items.create(attributes_for(:item, name: "orange"))

      user = create(:user)
      order = create(:order)
      item_order = user.item_orders.create!(order: order, item: @item_1, quantity: 1, price: @item_1.price)

      merchant_admin = create(:user, role: 2, merchant: @shop)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)
      visit merchant_user_index_path
    end

    describe "I can edit an item" do
      it "when I click a link to edit an item, I see a form with all fields auto-filled" do

        within "#item-#{@item_1.id}" do
          expect(page).to have_link("Edit")
          click_link("Edit")
        end

        expect(current_path).to eq(edit_merchant_user(@item_1))
      end
    end

  end
end
