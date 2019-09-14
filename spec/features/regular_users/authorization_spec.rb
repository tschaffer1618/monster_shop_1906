require 'rails_helper'

describe "As a regular user" do
  before(:each) do
    @regular_user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)
  end

  it 'the merchant path is inaccessible' do
    visit merchant_user_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

  it 'the admin path is inaccessible' do
    visit admin_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
