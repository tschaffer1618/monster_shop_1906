require 'rails_helper'

describe "As a merchant admin" do
  before(:each) do
    merchant = create(:merchant)
    @merchant_admin = create(:user, role: 2, merchant: merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
  end

  it 'the admin path is inaccessible' do
    visit admin_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
