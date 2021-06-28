# frozen_string_literal: true

class ReviewsController < ApplicationController
  def create
    @neta = Neta.find(params[:neta_id])
    @review = @neta.reviews.new(create_params)
    if @review.save
      rate_update_res = @neta.update_average_rate
      logger.error "#{rate_update_res[1]}. Neta id : #{@neta.id}" unless rate_update_res[0]
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
