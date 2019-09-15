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
      flash[:error] = @address.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def address_params
    params.require(:address).permit(:name, :street_address, :city, :state, :zipcode, :nickname)
  end
end
