class ReviewsController < ApplicationController

  def create
    @neta = Neta.find(params[:neta_id])
    @review = @neta.reviews.new(create_params)
    if @review.valid?
      Review.transaction do
        @review.save
        @neta.update_average_rate
      end
      redirect_to neta_path(@neta.id) and return
    else
      render :new and return
    end
  end

  private
  
  def create_params
    params.require(:review).permit(:text, :rate).merge(user_id: current_user.id)
  end

end