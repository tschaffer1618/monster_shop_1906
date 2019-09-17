class AddressesController < ApplicationController
  before_action :set_user

  def set_user
    @user = current_user
  end

  def new
    @address = Address.new
  end

  def create
    @address = @user.addresses.new(address_params)
    if @address.save
      flash[:success] = "New shipping address created"
      redirect_to profile_path
    else
      flash.now[:error] = @address.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @address = Address.find(params[:address_id])
  end

  def update
    @address = Address.find(params[:address_id])
    if @address.shipped_to?
      flash[:error] = "You cannot change an address with orders shipped to it"
      redirect_to profile_path
    else
      @address.update(address_params)
      if @address.save
        flash[:success] = "Shipping address updated"
        redirect_to profile_path
      else
        flash[:error] = @address.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  def destroy
    address = Address.find(params[:address_id])
    orders = Order.where(address_id: address.id)
    if address.shipped_to?
      flash[:error] = "You cannot delete an address with orders shipped to it"
    else
      orders.each do |order|
        order.update(address: nil)
      end
      address.destroy
      flash[:success] = "Shipping address deleted"
    end
    redirect_to profile_path
  end

  private

  def address_params
    params.require(:address).permit(:name, :street_address, :city, :state, :zipcode, :nickname)
  end
end
