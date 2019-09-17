require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @regular_user = User.create!(name: "George Jungle",
                    address: "1 Jungle Way",
                    city: "Jungleopolis",
                    state: "FL",
                    zipcode: "77652",
                    email: "junglegeorge@email.com",
                    password: "Tree123")

      @address_1 = @regular_user.addresses.create(name: @regular_user.name, street_address: @regular_user.address, city: @regular_user.city, state: @regular_user.state, zipcode: @regular_user.zipcode, nickname: 'home')
      @address_2 = @regular_user.addresses.create(name: 'Rex Dinosaur', street_address: '12 Toy Lane', city: 'Chicago', state: 'IL', zipcode: '75405', nickname: 'rex house')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit item_path(@paper)
      click_on "Add To Cart"
      visit item_path(@tire)
      click_on "Add To Cart"
      visit item_path(@pencil)
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout after choosing a shipping address' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")

      within "#address-#{@address_2.id}" do
        expect(page).to have_content(@address_2.nickname.capitalize)
        expect(page).to have_content(@address_2.name)
        expect(page).to have_content(@address_2.street_address)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zipcode)
        click_link "Choose This Address"
      end

      expect(current_path).to eq("/cart")
      expect(page).to have_content("You have chosen a shipping address")

      click_on "Checkout"

      expect(current_path).to eq('/profile/orders/new')
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end
end
