class Merchant::OrdersController < Merchant::BaseController
  def show
    @order = Order.find(params[:id])
    @item_orders = current_user.item_orders_by_merchant(@order.id)

    if @item_orders.empty?
      render file: "/public/404"
    end
  end

  def fulfill
    item_order = ItemOrder.find(params[:item_order_id])
    order = Order.find(item_order.order_id)
    item_order.update_status
    item_order.item.decrease_inventory(item_order)
    order.update_status
    flash[:success] = "Item order ##{item_order.id} has been fulfilled"
    redirect_to merchant_order_path(item_order.order)
  end
end
