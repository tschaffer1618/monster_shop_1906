require 'rails_helper'

describe 'As a merchant admin' do
  describe 'the nav bar' do
    before(:each) do
      merchant = create(:merchant)
      @merchant_admin = create(:user, role: 2, merchant: merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
      visit root_path
    end

    it 'has a link to the welcome page' do
      visit merchants_path

      within 'nav' do
        click_link('Home')
      end

      expect(current_path).to eq(root_path)
    end

    it 'has a link to all items' do
      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq(items_path)
    end

    it 'has a link to all merchants' do
      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq(merchants_path)
    end

    it 'does not have a link to all users' do
      within 'nav' do
        expect(page).to_not have_link('All Users')
      end
    end

    it 'does not have a link to login' do
      within 'nav' do
        expect(page).to_not have_link('Login')
      end
    end

    it 'does not have a link to register' do
      within 'nav' do
        expect(page).to_not have_link('Register')
      end
    end

    it 'has a link to a merchant dashboard' do
      within 'nav' do
        click_link('Merchant Dashboard')
      end

      expect(current_path).to eq(merchant_user_path)
    end

    it 'does not have a link to an admin dashboard' do
      within 'nav' do
        expect(page).to_not have_link('Admin Dashboard')
      end
    end

    it 'has a link to a profile' do
      within 'nav' do
        click_link('Profile')
      end

      expect(current_path).to eq(profile_path)
    end

    it 'has a link to logout' do
      within 'nav' do
        click_link('Logout')
      end

      expect(current_path).to eq(root_path)
    end

    it 'has a link to the cart' do
      within 'nav' do
        click_link("Cart: 0")
      end

      expect(current_path).to eq(cart_path)
    end
  end
end