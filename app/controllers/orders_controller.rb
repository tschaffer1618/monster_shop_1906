class OrdersController <ApplicationController

  def new

  end

  def cancel
    order = Order.find(params[:id])
    order.item_orders.each do |item_order|
      item_order.update(fulfilled?: false)
      item = Item.find(item_order.item_id)
      item_order.item.increase_inventory(item_order)
      item.save
    end
    order.status = "cancelled"
    order.save
    flash[:success] = "Your order has been cancelled"
    redirect_to "/profile"
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    user = current_user
    order = Order.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        user.item_orders.create({
          order: order,
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
    params.permit(:name, :address, :city, :state, :zip)
  end
end
