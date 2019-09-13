class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :nickname
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
