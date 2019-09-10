class ReviewsController<ApplicationController
  before_action :set_item

  def set_item
    @item = Item.find(params[:item_id])
  end

  def new
    @review = @item.reviews.new
  end

  def create
    if field_empty?
      flash[:error] = "Please fill in all fields in order to create a review."
      redirect_to new_item_review_path(@item)
    else
      @review = @item.reviews.create(review_params)
      if @review.save
        flash[:success] = "Review successfully created"
        redirect_to item_path(@item)
      else
        flash[:error] = "Rating must be between 1 and 5"
        render :new
      end
    end
  end

  def edit
    @review = @item.reviews.find(params[:id])
  end

  def update
    @review = @item.reviews.find(params[:id])
    @review.update(review_params)
    redirect_to item_path(@item)
  end

  def destroy
    review = @item.reviews.find(params[:id])
    item = review.item
    review.destroy
    redirect_to item_path(@item)
  end

  private

  def review_params
    if params[:review]
      params.require(:review).permit(:title,:content,:rating)
    else
      params.permit(:title,:content,:rating)
    end
  end

  def field_empty?
    params = review_params
    params[:title].empty? || params[:content].empty? || params[:rating].empty?
  end
end
