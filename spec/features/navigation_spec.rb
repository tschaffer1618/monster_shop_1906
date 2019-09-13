

  describe "As a Registered User" do
    it "I see profile and logout links but not login and register links on navigation bar" do
      regular_user = User.create!(name: "George Jungle",
                    address: "1 Jungle Way",
                    city: "Jungleopolis",
                    state: "FL",
                    zipcode: "77652",
                    email: "junglegeorge@email.com",
                    password: "Tree123")

      visit '/login'

      within 'nav' do
        click_link('Login')
      end

      fill_in :email, with: regular_user.email
      fill_in :password, with: regular_user.password

      click_button "Submit"

      expect(current_path).to eq('/profile')

      within 'nav' do
        expect(page).to have_link("Logout")
        expect(page).to have_link("Profile")

        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
      end

      expect(page).to have_content("Logged in as #{regular_user.name}")
    end
  end

  describe "As an Admin User" do
    it "I see appropriate links in the nav bar" do
      admin_user = User.create!(name: "Leslie Knope",
                    address: "14 Somewhere Ave",
                    city: "Pawnee",
                    state: "IN",
                    zipcode: "18501",
                    email: "recoffice@email.com",
                    password: "Waffles",
                    role: 3)

      visit '/login'

      within 'nav' do
        click_link('Login')
      end

      fill_in :email, with: admin_user.email
      fill_in :password, with: admin_user.password

      click_button "Submit"

      visit items_path

      within 'nav' do
        expect(page).to have_link("Logout")
        expect(page).to have_link("Profile")
        expect(page).to have_link("All Users")
        expect(page).to have_link("Admin Dashboard")


        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")
        expect(page).to_not have_link("Cart: 0")
      end
    end
  end

  describe "As a Merchant Employee/Admin" do
      before :each do
        @bike_shop = Merchant.create!(name: "Brian's Bike Shop",
                    address: '123 Bike Rd.',
                    city: 'Richmond',
                    state: 'VA',
                    zip: 23137)
        @merchant_user = @bike_shop.users.create!(name: "Michael Scott",
          address: "1725 Slough Ave",
          city: "Scranton",
          state: "PA",
          zipcode: "18501",
          email: "michael.s@email.com",
          password: "WorldBestBoss",
          role: 2)
        @merchant_employee = @bike_shop.users.create!(name: "Dwight Schrute",
          address: "175 Beet Rd",
          city: "Scranton",
          state: "PA",
          zipcode: "18501",
          email: "dwightkschrute@email.com",
          password: "IdentityTheftIsNotAJoke",
          role: 1)
      end

      it "I see profile, logout, and merchant dashboard links on navigation bar" do
        visit '/login'

        within 'nav' do
          click_link('Login')
        end

        fill_in :email, with: @merchant_user.email
        fill_in :password, with: @merchant_user.password

        click_button "Submit"

        expect(current_path).to eq('/merchant')

        within 'nav' do
          expect(page).to have_link("Logout")
          expect(page).to have_link("Profile")
          expect(page).to have_link("Merchant Dashboard")
          expect(page).to_not have_link("Login")
          expect(page).to_not have_link("Register")
        end

        expect(current_path).to eq('/merchant')
        expect(page).to have_content("Logged in as #{@merchant_user.name}")

        click_link "Logout"

        visit '/login'

        within 'nav' do
          click_link('Login')
        end

        fill_in :email, with: @merchant_employee.email
        fill_in :password, with: @merchant_employee.password

        click_button "Submit"

        expect(current_path).to eq('/merchant')

        within 'nav' do
          expect(page).to have_link("Logout")
          expect(page).to have_link("Profile")
          expect(page).to have_link("Merchant Dashboard")
          expect(page).to_not have_link("Login")
          expect(page).to_not have_link("Register")
        end

        expect(current_path).to eq('/merchant')
        expect(page).to have_content("Logged in as #{@merchant_employee.name}")
      end

      it "I get a 404 error when I try to access /admin paths" do
        visit admin_path
        expect(page).to have_content("The page you were looking for doesn't exist (404)")
      end
    end
