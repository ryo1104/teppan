class BranchAutocompleteController < ApplicationController
  def index
    bank = Bank.find_by(name: params[:bankname])
    items = bank.branches.ransack(name_or_namehira_start: params[:branchname]).result.order("namehira ASC").limit(5)
    render json: BankSerializer.new(items)
  end
end
