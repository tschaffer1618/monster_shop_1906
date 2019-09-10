class UsersController< ApplicationController
  before_action :require_user, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.name}! You are now registered and logged in."
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def show
    @user = current_user
    render :profile
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    if @user.save
      flash[:success] = "Your profile has been updated"
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to "/profile/edit"
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user
    @user.update(user_params)
    if @user.save
      flash[:success] = "Your password has been updated"
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to "/profile/edit_password"
    end
  end

  def show_orders
    @user = current_user
    @item_orders = @user.item_orders
  end

  private
  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :zipcode, :email, :password, :password_confirmation)
  end
end
