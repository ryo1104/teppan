class ApplicationController < ActionController::Base
  include ErrorUtils
  prepend_view_path Rails.root.join("frontend")
end
