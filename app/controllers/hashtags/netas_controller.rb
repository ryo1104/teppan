# frozen_string_literal: true

class Hashtags::NetasController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    hashname = params[:keyword]
    @tag = Hashtag.find_or_initialize_by(hashname: hashname)
    if @tag.persisted?
      @netas = @tag.netas.includes(:user).order('average_rate DESC')
      @tag.add_hit(current_user) if user_signed_in?
    end
  end
end
