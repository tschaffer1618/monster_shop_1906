class MerchantsController <ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.create(merchant_params)
    if @merchant.save
      redirect_to merchants_path
    else
      flash[:error] = @merchant.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update(merchant_params)
    if @merchant.save
      redirect_to merchant_path(@merchant)
    else
      flash[:error] = @merchant.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    Item.delete(Item.where(merchant_id: params[:id]))
    Merchant.destroy(params[:id])
    redirect_to merchants_path
  end

  def update_status
    @merchant = Merchant.find(params[:id])
    @merchant.update(status_params)
    if @merchant.enabled?
      @merchant.activate_items
      flash[:success] = "#{@merchant.name} is now enabled"
    else
      @merchant.deactivate_items
      flash[:success] = "#{@merchant.name} is now disabled"
    end
    redirect_to merchants_path
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name,:address,:city,:state,:zip,:enabled?)
  end

  def status_params
    params.require(:merchant).permit(:enabled?)
  end

end
