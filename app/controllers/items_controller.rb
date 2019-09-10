class ItemsController<ApplicationController
  before_action :current_merchant_employee?, :current_merchant_admin?, only: [:create]

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = current_user.merchant
    item = @merchant.items.create(item_params)

    if item.image.blank?
      item.image = "https://avatars3.githubusercontent.com/u/6475745?s=88&v=4"
    end
    
    if item.save
      flash[:new_item] = "Your new item is saved!"
      redirect_to merchant_user_index_path
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    if @item.save
      redirect_to "/items/#{@item.id}"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to items_path
  end

  private
  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
