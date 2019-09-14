require 'rails_helper'

describe "As an admin user" do
  before(:each) do
    @admin_user = create(:user, role: 3)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
  end

  it 'the merchant path is inaccessible' do
    visit merchant_user_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

  it 'the cart path is inaccessible' do
    visit cart_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
