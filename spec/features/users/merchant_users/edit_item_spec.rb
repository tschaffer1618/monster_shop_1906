require 'rails_helper'

RSpec.describe "Merchant Items Page" do
  describe "As a merchant admin" do
    before :each do
      @shop = create(:merchant)
      @item_1 = @shop.items.create(name: "apple", description: "fresh", price: 10.00, image: "https://avatars3.githubusercontent.com/u/6475745?s=88&v=4", active?: true, inventory: 30)
      @item_2 = @shop.items.create(attributes_for(:item, name: "orange"))

      user = create(:user)
      address_1 = user.addresses.create(name: user.name, street_address: user.address, city: user.city, state: user.state, zipcode: user.zipcode, nickname: 'home')
      order = address_1.orders.create
      item_order = order.item_orders.create(item: @item_1, quantity: 1, price: @item_1.price)

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

        expect(current_path).to eq(edit_merchant_user_path(@item_1))

        expect(find_field('Name').value).to eq 'apple'
        expect(find_field('Description').value).to eq 'fresh'
        expect(find_field('Price').value).to eq '10'
        expect(find_field('Image').value).to eq "https://avatars3.githubusercontent.com/u/6475745?s=88&v=4"
        expect(find_field('Inventory').value).to eq '30'

        click_on("Update Item")
        expect(current_path).to eq(merchant_user_index_path)
        expect(page).to have_content("Your item is now updated!")
        expect(page).to have_css("img[src*='https://avatars3.githubusercontent.com/u/6475745?s=88&v=4']")

        visit merchant_user_index_path

        within "#item-#{@item_2.id}" do
          expect(page).to have_link("Edit")
          click_link("Edit")
        end

        expect(current_path).to eq(edit_merchant_user_path(@item_2))

        fill_in 'Name', with: ''
        fill_in 'Price', with: ''

        click_on("Update Item")

        expect(page).to have_content("Name can't be blank, Price can't be blank, and Price is not a number")
      end
    end

  end
end
