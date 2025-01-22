class ApplicationController < ActionController::Base
  include Pundit::Authorization
  add_flash_types :success

  IdType = String
end
