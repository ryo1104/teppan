class OffersController < ApplicationController
  
  def new
    @request = Request.find(params[:request_id])
    @offer = Offer.new
  end
  
  def create
    Offer.create(create_params)
    redirect_to request_path(params[:request_id])
  end
  
  def show
    @offer = Offer.find(params[:id])
    @request = Request.find(@offer.request_id)
    @i_am = @offer.who_am_i(current_user)
    
    @comments = @offer.comments
    @newcomment = Comment.new
    
    unless @i_am == "offerer"
      @offer.pageviews.create(user_id: current_user.id)
    end
  end
  
  def edit
    @offer = Offer.find(params[:id])
    @request = Request.find(@offer.request_id)
  end
  
  def update
    offer = Offer.find(params[:id])
    offer.update(update_params)
    redirect_to request_path(offer.request_id)
  end
  
  def destroy
    offer = Offer.find(params[:id])
    @request_id = offer.request_id
    offer.delete
    redirect_to request_path(@request_id)
  end

  private
  
  def create_params
    params.require(:offer).permit(:text, :price, :required_days).merge(user_id: current_user.id, request_id: params[:request_id])
  end

  def update_params
    params.require(:offer).permit(:text, :price, :required_days)
  end
  
end
