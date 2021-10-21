# frozen_string_literal: true

class TokuteisController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show; end
end
