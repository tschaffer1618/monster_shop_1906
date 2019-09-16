require 'rails_helper'

describe 'As a user' do
  before :each do
    @user = create(:user)
    @address_1 = @user.addresses.create(name: @user.name, street_address: @user.address, city: @user.city, state: @user.state, zipcode: @user.zipcode, nickname: 'home')

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'I can delete a shipping address' do
    visit profile_path

    within "#address-#{@address_1.id}" do
      click_link "Delete"
    end

    expect(current_path).to eq(profile_path)

    expect(page).to have_content("Shipping address deleted")
  end
end
