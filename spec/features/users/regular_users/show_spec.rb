require 'rails_helper'

RSpec.describe "User Profile" do
  before :each do
    @regular_user = User.create!(name: "George Jungle",
                  address: "1 Jungle Way",
                  city: "Jungleopolis",
                  state: "FL",
                  zipcode: "77652",
                  email: "junglegeorge@email.com",
                  password: "Tree123")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)
    visit '/profile'
  end

  it 'can show the users info' do

    within "#user-info-#{@regular_user.id}" do
      expect(page).to have_content(@regular_user.name)
      expect(page).to have_content(@regular_user.address)
      expect(page).to have_content(@regular_user.city)
      expect(page).to have_content(@regular_user.state)
      expect(page).to have_content(@regular_user.zipcode)
      expect(page).to have_content(@regular_user.email)
    end

    within "#user-profile-actions" do
      expect(page).to have_link("Edit Profile")
    end
  end
end
