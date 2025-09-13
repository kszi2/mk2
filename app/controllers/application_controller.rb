class ApplicationController < ActionController::Base
  include Pundit::Authorization
  add_flash_types :success

  IdType = String

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    redirect_to unauthorized_url(back: request.referer)
  end
end
