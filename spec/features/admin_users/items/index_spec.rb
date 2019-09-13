require 'rails_helper'

describe 'As an admin user' do
  describe 'the items index page' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @item_1 = @merchant_1.items.create(attributes_for(:item))
      @item_2 = @merchant_2.items.create(attributes_for(:item))
      @item_3 = @merchant_2.items.create(attributes_for(:item, active?: false))
      @admin_user = create(:user, role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
      visit items_path
    end

    it 'displays all pertinent item info with links to items and merchants' do
      within "#item-#{@item_1.id}" do
        expect(page).to have_link(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_content("Price: $#{@item_1.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@item_1.inventory}")
        expect(page).to have_link(@merchant_1.name)
        expect(page).to have_css("img[src*='#{@item_1.image}']")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_link(@item_2.name)
        expect(page).to have_content(@item_2.description)
        expect(page).to have_content("Price: $#{@item_2.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@item_2.inventory}")
        expect(page).to have_link(@merchant_2.name)
        expect(page).to have_css("img[src*='#{@item_2.image}']")
      end
    end

    it 'does not display inactive items' do
      expect(page).to_not have_link(@item_3.name)
      expect(page).to_not have_content(@item_3.description)
      expect(page).to_not have_content("Price: $#{@item_3.price}")
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@item_3.inventory}")
    end

    xit 'displays the five most and least popular items' do
      merchant_3 = create(:merchant)
      item_4 = merchant_3.items.create(attributes_for(:item, name: "apple"))
      item_5 = merchant_3.items.create(attributes_for(:item, name: "orange"))
      item_6 = merchant_3.items.create(attributes_for(:item, name: "banana"))
      item_7 = merchant_3.items.create(attributes_for(:item, name: "pear"))
      item_8 = merchant_3.items.create(attributes_for(:item, name: "lychee"))
      item_9 = merchant_3.items.create(attributes_for(:item, name: "watermelon"))

      user = create(:user)
      order_1 = create(:order)
      item_order_1 = user.item_orders.create!(order: order_1, item: item_6, quantity: 6, price: item_6.price)
      item_order_2 = user.item_orders.create!(order: order_1, item: item_5, quantity: 5, price: item_5.price)
      item_order_3 = user.item_orders.create!(order: order_1, item: item_4, quantity: 4, price: item_4.price)
      item_order_4 = user.item_orders.create!(order: order_1, item: item_3, quantity: 3, price: item_3.price)

      order_2 = create(:order)
      item_order_5 = user.item_orders.create!(order: order_2, item: item_6, quantity: 6, price: item_6.price)
      item_order_6 = user.item_orders.create!(order: order_2, item: item_1, quantity: 1, price: item_1.price)
      item_order_7 = user.item_orders.create!(order: order_2, item: item_2, quantity: 2, price: item_2.price)
      item_order_8 = user.item_orders.create!(order: order_2, item: item_3, quantity: 3, price: item_3.price)

      visit items_path

      expect(page).to have_content("Item Statistics")
      expect(page).to have_content("Top 5 Items")
      expect(page).to have_content("Bottom 5 Items")

      within "#top_five" do
        expect(page).to have_content(item_6.name)
        expect(page).to have_content(12)
        expect(page).to have_content(item_3.name)
        expect(page).to have_content(6)
        expect(page).to have_content(item_5.name)
        expect(page).to have_content(5)
        expect(page).to have_content(item_4.name)
        expect(page).to have_content(4)
        expect(page).to have_content(item_2.name)
        expect(page).to have_content(2)
        expect(page).not_to have_content(item_1.name)
      end

      within "#bottom_five" do
        expect(page).to have_content(item_1.name)
        expect(page).to have_content(1)
        expect(page).to have_content(item_3.name)
        expect(page).to have_content(6)
        expect(page).to have_content(item_5.name)
        expect(page).to have_content(5)
        expect(page).to have_content(item_4.name)
        expect(page).to have_content(4)
        expect(page).to have_content(item_2.name)
        expect(page).to have_content(2)
        expect(page).not_to have_content(item_6.name)
      end
    end
  end
end
