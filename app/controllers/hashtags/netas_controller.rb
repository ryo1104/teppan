class Hashtags::NetasController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    hashname = params[:keyword]
    if @tag = Hashtag.find_by(hashname: hashname)
      @tag.add_hit(current_user) if user_signed_in?
      @netas = @tag.netas.includes(:hashtag_netas, :hashtags, {user: [image_attachment: :blob]}).order("average_rate DESC")
    else
      @tag = Hashtag.new(hashname: hashname)
      @netas = nil
    end
  end

end
