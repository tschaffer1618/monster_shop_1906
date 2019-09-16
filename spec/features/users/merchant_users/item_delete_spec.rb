require 'rails_helper'

RSpec.describe "Merchant Items Page" do
  describe "As a merchant admin" do
    before :each do
      shop = create(:merchant)
      @item_1 = shop.items.create!(attributes_for(:item, name: "apple"))  # order placed, cannot delete
      @item_2 = shop.items.create!(attributes_for(:item, name: "orange")) # order not placed, can delete

      user = create(:user)
      address_1 = user.addresses.create(name: user.name, street_address: user.address, city: user.city, state: user.state, zipcode: user.zipcode, nickname: 'home')
      order = address_1.orders.create(user: user)
      item_order = order.item_orders.create(item: @item_1, quantity: 1, price: @item_1.price)

      merchant_admin = create(:user, role: 2, merchant: shop)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)
      visit merchant_user_index_path
    end

    it "I see a link to delete the item next to each item that has never been ordered" do

      within "#item-#{@item_1.id}" do
        expect(page).to_not have_link("Delete")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_link("Delete")
      end
    end

    it "once the item is deleted, I see a flash message and I no longer see the item on the page" do

      within "#item-#{@item_2.id}" do
        click_link "Delete"
      end

      expect(current_path).to eq(merchant_user_index_path)
      expect(page).to have_content("#{@item_2.name} is now deleted!")
      expect(page).to_not have_content("##{@item_2.id}")
      expect(page).to have_content("##{@item_1.id}")
    end
  end
end
