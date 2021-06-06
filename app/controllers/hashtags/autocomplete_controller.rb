# frozen_string_literal: true

class Hashtags::AutocompleteController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    items = Hashtag.ransack(hashname_or_yomigana_cont: params[:keyword]).result.order('neta_count DESC').limit(10)
    render json: HashtagSerializer.new(items)
  end
end
