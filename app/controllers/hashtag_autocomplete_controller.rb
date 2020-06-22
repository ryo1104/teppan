class HashtagAutocompleteController < ApplicationController
  def index
    items = Hashtag.ransack(hashname_or_hiragana_cont: params[:keyword]).result.order("neta_count DESC").limit(10)
    render json: HashtagSerializer.new(items)    
  end
end
