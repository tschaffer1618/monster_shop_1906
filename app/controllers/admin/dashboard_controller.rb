class Admin::DashboardController < Admin::BaseController
  def index
    @admin_user = current_user
    @orders = Order.order(status: :asc)
  end

  def update_status
    order = Order.find(params[:order_id])
    order.update(status: 2)
    flash[:success] = "Order ##{order.id} has been shipped!"
    redirect_to admin_path
  end
end
