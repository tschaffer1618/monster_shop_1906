require 'rails_helper'

RSpec.describe "Merchant Dashboard" do
  # before :each do
  #   @merchant_1 = create(:merchant)
  #
  #   @item_1 = @merchant_1.items.create!(attributes_for(:item))
  #   @item_2 = @merchant_1.items.create!(attributes_for(:item))
  #
  #   @merchant_admin = create(:user, role: 2, merchant: @merchant_1)
  #   @merchant_employee = create(:user, role: 1, merchant: @merchant_1)
  # end

  it 'merchant admin sees link to view shop items' do
    merchant_1 = create(:merchant)

    item_1 = merchant_1.items.create!(attributes_for(:item))
    item_2 = merchant_1.items.create!(attributes_for(:item))

    merchant_admin = create(:user, role: 2, merchant: merchant_1)
    merchant_employee = create(:user, role: 1, merchant: merchant_1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit merchant_user_path

    within "#dashboard-link" do
      click_link("View Items")
    end

    expect(current_path).to eq(merchant_user_index_path)

    within "#item-#{item_1.id}" do
      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_1.description)
      expect(page).to have_content(item_1.price)
      expect(page).to have_content(item_1.inventory)
      expect(page).to have_content("Active")
    end

    within "#item-#{item_2.id}" do
      expect(page).to have_content(item_2.name)
      expect(page).to have_content(item_2.description)
      expect(page).to have_content(item_2.price)
      expect(page).to have_content(item_2.inventory)
      expect(page).to have_content("Active")
    end
  end

  it 'merchant admin can activate/deactivate shop items' do
    merchant_1 =  Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

    merchant_admin = User.create!(name: "Michael Scott",
                  address: "1725 Slough Ave",
                  city: "Scranton",
                  state: "PA",
                  zipcode: "18501",
                  email: "michael.s@email.com",
                  password: "WorldBestBoss",
                  role: 2,
                  merchant: merchant_1)

    item_1 = merchant_1.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    visit "/login"

    fill_in :email, with: merchant_admin.email
    fill_in :password, with: merchant_admin.password

    click_button "Submit"

    visit merchant_user_index_path

    within "#item-#{item_1.id}" do
      click_button "Deactivate"
    end

    expect(current_path).to eq(merchant_user_index_path)
    expect(page).to have_content("This item is no longer for sale")

    within "#item-#{item_1.id}" do
      expect(page).to have_content("Inactive")
      click_button "Activate"
    end

    expect(current_path).to eq(merchant_user_index_path)
    expect(page).to have_content("This item is now available for sale")
  end


  it 'merchant employee sees link to view shop items' do
    merchant_1 = create(:merchant)

    item_1 = merchant_1.items.create!(attributes_for(:item))
    item_2 = merchant_1.items.create!(attributes_for(:item))

    merchant_admin = create(:user, role: 2, merchant: merchant_1)
    merchant_employee = create(:user, role: 1, merchant: merchant_1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

    visit merchant_user_path

    within "#dashboard-link" do
      click_link("View Items")
    end

    expect(current_path).to eq(merchant_user_index_path)

    within "#item-#{item_1.id}" do
      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_1.description)
      expect(page).to have_content(item_1.price)
      expect(page).to have_content(item_1.inventory)
      expect(page).to have_content("Active")
    end

    within "#item-#{item_2.id}" do
      expect(page).to have_content(item_2.name)
      expect(page).to have_content(item_2.description)
      expect(page).to have_content(item_2.price)
      expect(page).to have_content(item_2.inventory)
      expect(page).to have_content("Active")
    end
  end
end
