require 'rails_helper'

describe 'As a user' do
  before :each do
    @user = create(:user)
    @address_1 = @user.addresses.create(name: @user.name, street_address: @user.address, city: @user.city, state: @user.state, zipcode: @user.zipcode, nickname: 'home')
    @address_2 = @user.addresses.create(name: 'Rex Dinosaur', street_address: '12 Toy Lane', city: 'Chicago', state: 'IL', zipcode: '75405', nickname: 'rex house')

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'I see all my shipping addresses on my profile page' do
    visit profile_path

    within "#address-#{@address_1.id}" do
      expect(page).to have_content(@address_1.nickname.capitalize)
      expect(page).to have_content(@address_1.name)
      expect(page).to have_content(@address_1.street_address)
      expect(page).to have_content(@address_1.city)
      expect(page).to have_content(@address_1.state)
      expect(page).to have_content(@address_1.zipcode)
    end

    within "#address-#{@address_2.id}" do
      expect(page).to have_content(@address_2.nickname.capitalize)
      expect(page).to have_content(@address_2.name)
      expect(page).to have_content(@address_2.street_address)
      expect(page).to have_content(@address_2.city)
      expect(page).to have_content(@address_2.state)
      expect(page).to have_content(@address_2.zipcode)
    end
  end
end
