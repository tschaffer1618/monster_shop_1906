require 'rails_helper'

RSpec.describe "Merchant Dashboard" do
  before :each do
    @merchant_1 = create(:merchant)

    @item_1 = @merchant_1.items.create!(attributes_for(:item))
    @item_2 = @merchant_1.items.create!(attributes_for(:item))

    @merchant_admin = create(:user, role: 1, merchant: @merchant_1)
    @merchant_employee = create(:user, role: 2, merchant: @merchant_1)
  end

  it 'merchant admin sees link to view shop items' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)

    visit merchant_user_path

    within "#dashboard-link" do
      click_link("View Items")
    end

    expect(current_path).to eq(merchant_user_index_path)

    within "#item-#{@item_1.id}" do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.description)
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content(@item_1.inventory)
      expect(page).to have_content(@item_1.active?)
    end

    within "#item-#{@item_2.id}" do
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_2.description)
      expect(page).to have_content(@item_2.price)
      expect(page).to have_content(@item_2.inventory)
      expect(page).to have_content(@item_2.active?)
    end
  end

  it 'merchant admin can activate/deactivate shop items' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)

    visit merchant_user_index_path

    within "#item-#{@item_1.id}" do
      click_link "Deactivate"
    end

    expect(current_path).to eq(merchant_user_index_path)
    expect(page).to have_content("This item is no longer for sale")

    within "#item-#{@item_1.id}" do
      click_link "Activate"
    end

    expect(current_path).to eq(merchant_user_index_path)
    expect(page).to have_content("This item is now available for sale")
  end


  it 'merchant employee sees link to view shop items' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)

    visit merchant_user_path

    within "#dashboard-link" do
      click_link("View Items")
    end

    expect(current_path).to eq(merchant_user_index_path)

    within "#item-#{@item_1.id}" do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.description)
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content(@item_1.inventory)
      expect(page).to have_content(@item_1.active?)
    end

    within "#item-#{@item_2.id}" do
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_2.description)
      expect(page).to have_content(@item_2.price)
      expect(page).to have_content(@item_2.inventory)
      expect(page).to have_content(@item_2.active?)
    end
  end
end
