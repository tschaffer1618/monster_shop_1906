class CartController < ApplicationController
  before_action :check_for_admin_user

  def check_for_admin_user
    render file: "/public/404" if current_admin?
  end

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)

    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to items_path
  end

  def show
    @user = current_user
    if visitor_with_items?
      flash.now[:error] = "Please #{view_context.link_to 'register', register_path} or #{view_context.link_to 'login', login_path} to continue your checkout process.".html_safe
    end
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increment_decrement
    if params[:increment_decrement] == "increment"
      cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
    elsif params[:increment_decrement] == "decrement"
      cart.subtract_quantity(params[:item_id])
      return remove_item if cart.quantity_zero?(params[:item_id])
    end
    redirect_to "/cart"
  end

  # def add_address
  #   address = Address.find(params[:address_id])
  #   cart.add_address(address)
  #   flash[:success] = "You have chosen a shipping address"
  #   redirect_to "/cart"
  # end
end
