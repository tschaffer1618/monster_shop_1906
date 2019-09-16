class OrdersController < ApplicationController

  def new
    @user = current_user
    @order = Order.new
  end

  def cancel
    order = Order.find(params[:id])
    order.cancel_order
    order.update(status: 3)
    order.save

    flash[:success] = "Your order has been cancelled"
    redirect_to "/profile"
  end

  def create
    @user = current_user
    @order = @user.orders.create(order_params)
    if @order.save
      cart.items.each do |item,quantity|
        @order.item_orders.create({
          order: @order,
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:order] = "Your order has been created!"
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  private
  def order_params
    params.require(:order).permit(:status)
  end
end
