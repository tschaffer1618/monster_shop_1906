require 'rails_helper'

describe User, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zipcode}
    it {should validate_presence_of :email}
    it {should validate_presence_of :password}

    it {should validate_confirmation_of(:password).on(:create)}

    it {should validate_uniqueness_of(:email).case_insensitive}
    it {should allow_value('user@example.com').for(:email)}
    it {should_not allow_value("foo").for(:email)}
  end

  describe "relationships" do
    it {should have_many :addresses}
    it {should have_many(:orders).through(:addresses)}
    it {should have_many(:item_orders).through(:orders)}
    it {should belong_to(:merchant).optional }
  end

  describe "roles" do
    it "can be created as a default user" do
      regular_user = User.create!(name: "George Jungle",
                    address: "1 Jungle Way",
                    city: "Jungleopolis",
                    state: "FL",
                    zipcode: "77652",
                    email: "junglegeorge@email.com",
                    password: "Tree123")

      expect(regular_user.role).to eq("regular_user")
      expect(regular_user.regular_user?).to be_truthy
    end

    it "can be created as a merchant employee" do
      merchant_employee = User.create!(name: "Dwight Schrute",
        address: "175 Beet Rd",
        city: "Scranton",
        state: "PA",
        zipcode: "18501",
        email: "dwightkschrute@email.com",
        password: "IdentityTheftIsNotAJoke",
        role: 1)

      expect(merchant_employee.role).to eq("merchant_employee")
      expect(merchant_employee.merchant_employee?).to be_truthy
    end

    it "can be created as a merchant admin" do
      merchant_admin = User.create!(name: "Michael Scott",
                    address: "1725 Slough Ave",
                    city: "Scranton",
                    state: "PA",
                    zipcode: "18501",
                    email: "michael.s@email.com",
                    password: "WorldBestBoss",
                    role: 2)

      expect(merchant_admin.role).to eq("merchant_admin")
      expect(merchant_admin.merchant_admin?).to be_truthy
    end

    it "can be created as a admin user" do
      admin_user = User.create!(name: "Leslie Knope",
                    address: "14 Somewhere Ave",
                    city: "Pawnee",
                    state: "IN",
                    zipcode: "18501",
                    email: "recoffice@email.com",
                    password: "Waffles",
                    role: 3)

      expect(admin_user.role).to eq("admin_user")
      expect(admin_user.admin_user?).to be_truthy
    end
  end

  describe "creating users with factory bot" do
    before(:each) do
      user_1 = create(:user, email: "bob@gmail.com")
    end

    it "a different type of user has valid attributes" do
      regular_user = create(:user)
      merchant_employee = create(:user, role: 1)
      merchant_admin = create(:user, role: 2)
      admin_user = create(:user, role: 3)

      expect(regular_user).to be_valid
      expect(merchant_employee).to be_valid
      expect(merchant_admin).to be_valid
      expect(admin_user).to be_valid
    end

    it "a new user must have a unique email" do
      user_2 = build(:user, email: "bob@gmail.com")
      expect(user_2).to_not be_valid
    end
  end

  describe "methods" do
    it 'can find item orders by merchant user with order id' do
      regular_user_1 = create(:user)

      address_1 = regular_user_1.addresses.create(name: 'Rex Dinosaur', street_address: '12 Toy Lane', city: 'Chicago', state: 'IL', zipcode: '75405', nickname: 'rex house')

      merchant_shop_1 = create(:merchant, name: "Merchant Shop 1")
        item_1 = merchant_shop_1.items.create(attributes_for(:item, name: "Item 1" ))
        item_2 = merchant_shop_1.items.create(attributes_for(:item, name: "Item 2"))

      order_1 = address_1.orders.create
        item_order_1 = order_1.item_orders.create(item: item_1, quantity: 2, price: item_1.price)
        item_order_2 = order_1.item_orders.create(item: item_2, quantity: 8, price: item_2.price)

      order_2 = address_1.orders.create
        item_order_4 = order_2.item_orders.create(item: item_2, quantity: 18, price: item_2.price)

      merchant_admin = create(:user, role: 2, merchant: merchant_shop_1)

      expected = [item_order_1, item_order_2]

      expect(expected).to eq(merchant_admin.item_orders_by_merchant(order_1))
    end

    it 'home_address' do
      regular_user_1 = create(:user)
      address_1 = regular_user_1.addresses.create(name: 'Rex Dinosaur', street_address: '12 Toy Lane', city: 'Chicago', state: 'IL', zipcode: '75405', nickname: 'home')

      expect(regular_user_1.home_address).to eq(address_1)
    end
  end
end
