class ApplicationController < ActionController::Base
  include ErrorUtils
  before_action :authenticate_user!
end
