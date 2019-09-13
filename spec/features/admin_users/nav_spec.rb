require 'rails_helper'

describe 'As an admin user' do
  describe 'the nav bar' do
    before(:each) do
      @admin_user = create(:user, role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin_user)
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

    it 'has a link to all users' do
      within 'nav' do
        click_link('All Users')
      end

      expect(current_path).to eq(admin_users_path)
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

    it 'does not have a link to a merchant dashboard' do
      within 'nav' do
        expect(page).to_not have_link('Merchant Dashboard')
      end
    end

    it 'has a link to an admin dashboard' do
      within 'nav' do
        click_link('Admin Dashboard')
      end

      expect(current_path).to eq(admin_path)
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

    it 'does not have a link to the cart' do
      within 'nav' do
        expect(page).to_not have_link('Cart: 0')
      end
    end
  end
end
