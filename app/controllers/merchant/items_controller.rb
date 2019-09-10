class Merchant::ItemsController < Merchant::BaseController
  before_action :current_merchant_admin?
  before_action :set_merchant, only: [:index, :new, :create]

  def set_merchant
    @merchant = current_user.merchant
  end

  def index
    @items = @merchant.items
  end

  def new
    @item = Item.new
  end

  def create
    @item = @merchant.items.create(item_params)

    if @item.save
      if @item.image.blank?
        @item.image = "https://avatars3.githubusercontent.com/u/6475745?s=88&v=4"
      end
      flash[:new_item] = "Your new item is saved!"
      redirect_to merchant_user_index_path
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end
end
