class Admin::DashboardController < Admin::BaseController
  def index
    @admin_user = current_user
    @orders = Order.order(status: :asc)
    @users = User.all
  end
end
