class Admin::DashboardController < Admin::BaseController
  def index
    @admin_user = current_user
    @orders = Order.all
    @users = User.all
  end
end
