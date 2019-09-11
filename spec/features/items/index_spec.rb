require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit items_path

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit items_path

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end
    end

    it "disabled items are not shown" do
      visit items_path

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it "shows an area with statistics of top/bottom 5 most/least popular items (by quantity purchased), plus that quantity" do
      shop = create(:merchant)
      item_1 = shop.items.create(attributes_for(:item, name: "apple"))
      item_2 = shop.items.create(attributes_for(:item, name: "orange"))
      item_3 = shop.items.create(attributes_for(:item, name: "banana"))
      item_4 = shop.items.create(attributes_for(:item, name: "pear"))
      item_5 = shop.items.create(attributes_for(:item, name: "lychee"))
      item_6 = shop.items.create(attributes_for(:item, name: "watermelon"))

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
