class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :allow_iframe

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def check_user
    unless current_user
      store_location_for :user, url_for(:only_path => false)
      redirect_to  user_accounts_api_omniauth_authorize_path(provider: 'accounts_api')
    end
  end

  class NotAuthorized < Exception
  end
end
