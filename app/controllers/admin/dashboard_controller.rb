class Admin::DashboardController < Admin::BaseController
  def index
    @admin_user = current_user
    #need to move into model?
    @orders = Order.order(status: :asc)
    @users = User.all
  end
end
