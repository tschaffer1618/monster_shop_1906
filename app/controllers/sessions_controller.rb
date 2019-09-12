class SessionsController < ApplicationController
  def new
    if session[:user_id].nil?
      render "users/login"
    else
      user = current_user
      flash[:notice] = "You are already logged in"
      if user.admin_user?
        redirect_to admin_path
      elsif user.merchant_admin? || user.merchant_employee?
        redirect_to "/merchant"
      else
        redirect_to profile_path
      end
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      flash[:success] = "Logged in as #{user.name}"
      session[:user_id] = user.id
      if user.admin_user?
        redirect_to admin_path
      elsif user.merchant_admin? || user.merchant_employee?
        redirect_to "/merchant"
      else
        redirect_to "/profile"
      end
    else
      flash[:error] = "Please enter valid user information"
      redirect_to "/login"
    end
  end

  def destroy
    session.delete(:user_id)
    current_user = nil
    cart.contents.clear
    redirect_to root_path
    flash[:success] = "You have been logged out!"
  end
end
