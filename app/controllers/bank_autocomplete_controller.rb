class BankAutocompleteController < ApplicationController
  def index
    items = Bank.ransack(name_or_namehira_start: params[:keyword]).result.order("namehira ASC").limit(5)
    render json: BankSerializer.new(items)
  end
end
