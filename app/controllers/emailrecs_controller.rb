# frozen_string_literal: true

class EmailrecsController < ApplicationController
  def index
    @emails = Emailrec.all.order('created_at DESC')
  end

  def show
    @email = Emailrec.find(params[:id])
  end
end
