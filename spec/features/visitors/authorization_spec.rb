require 'rails_helper'

describe "As a visitor" do
  it 'the merchant path is inaccessible' do
    visit merchant_user_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

  it 'the admin path is inaccessible' do
    visit admin_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

  it 'the profile path is inaccessible' do
    visit profile_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
