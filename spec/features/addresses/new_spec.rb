require 'rails_helper'

describe 'As a user' do
  before :each do
    @user = create(:user)
    @address_1 = @user.addresses.create(name: @user.name, street_address: @user.address, city: @user.city, state: @user.state, zipcode: @user.zipcode, nickname: 'home')

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'I can create a new shipping address' do
    visit profile_path

    click_link "Create a New Shipping Address"

    expect(current_path).to eq(profile_addresses_new_path)

    name = 'Fred Flintstone'
    street_address = '13 Mulberry Court'
    city = 'Cave'
    state = 'BC'
    zipcode = '34567'
    nickname = "fred's house"

    fill_in 'Name', with: name
    fill_in 'Street address', with: street_address
    fill_in 'City', with: city
    fill_in 'State', with: state
    fill_in 'Zipcode', with: zipcode
    fill_in 'Nickname', with: nickname

    click_button "Create Address"

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("New shipping address created")

    new_address = Address.last

    within "#address-#{new_address.id}" do
      expect(page).to have_content(new_address.nickname.capitalize)
      expect(page).to have_content(new_address.name)
      expect(page).to have_content(new_address.street_address)
      expect(page).to have_content(new_address.city)
      expect(page).to have_content(new_address.state)
      expect(page).to have_content(new_address.zipcode)
    end
  end
end
