class RemoveUsersFromItemOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :item_orders, :user, foreign_key: true
  end
end
