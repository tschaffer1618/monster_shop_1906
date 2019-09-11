require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    end

    it 'I can see a list of merchants in the system' do
      visit merchants_path

      expect(page).to have_link("Brian's Bike Shop")
      expect(page).to have_link("Meg's Dog Shop")
    end

    it 'I can see a link to create a new merchant as an admin user only' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit merchants_path
      expect(page).to_not have_link("New Merchant")

      merchant_employee = create(:user, role: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)
      visit merchants_path
      expect(page).to_not have_link("New Merchant")

      merchant_admin = create(:user, role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)
      visit merchants_path
      expect(page).to_not have_link("New Merchant")

      admin = create(:user, role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
      visit merchants_path
      expect(page).to have_link("New Merchant")

      click_on "New Merchant"

      expect(current_path).to eq(new_merchant_path)
    end
  end
end
