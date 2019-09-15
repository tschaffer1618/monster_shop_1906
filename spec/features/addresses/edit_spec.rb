require 'rails_helper'

describe 'As a user' do
  before :each do
    @user = create(:user)
    @address_1 = @user.addresses.create(name: @user.name, street_address: @user.address, city: @user.city, state: @user.state, zipcode: @user.zipcode, nickname: 'home')

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'I can edit a shipping address' do
    visit profile_path

    within "#address-#{@address_1.id}" do
      click_link "Edit Address"
    end

    expect(current_path).to eq("/profile/addresses/#{@address_1.id}/edit")

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

    click_button "Update Address"

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Shipping address updated")

    within "#address-#{@address_1.id}" do
      expect(page).to have_content(@address_1.nickname.capitalize)
      expect(page).to have_content(@address_1.name)
      expect(page).to have_content(@address_1.street_address)
      expect(page).to have_content(@address_1.city)
      expect(page).to have_content(@address_1.state)
      expect(page).to have_content(@address_1.zipcode)
    end
  end

  it 'I cannot edit a shipping address if the form is not filled in' do
    visit profile_path

    within "#address-#{@address_1.id}" do
      click_link "Edit Address"
    end

    expect(current_path).to eq("/profile/addresses/#{@address_1.id}/edit")

    name = 'Fred Flintstone'
    street_address = '13 Mulberry Court'
    city = 'Cave'
    state = 'BC'
    zipcode = '34567'
    nickname = "fred's house"

    fill_in 'Name', with: name
    fill_in 'Street address', with: ""
    fill_in 'City', with: city
    fill_in 'State', with: state
    fill_in 'Zipcode', with: zipcode
    fill_in 'Nickname', with: ""

    click_button "Update Address"

    expect(current_path).to eq("/profile/addresses/#{@address_1.id}")
    expect(page).to have_content("Street address can't be blank and Nickname can't be blank")
  end
end
