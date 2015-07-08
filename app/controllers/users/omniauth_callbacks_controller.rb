class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def accounts_api
    @user = User.find_for_accounts_api(request.env['omniauth.auth'])

    if @user
      sign_in_and_redirect @user, :event => :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => 'accounts api') if is_navigational_format?
    else
      redirect_to :root, notice: 'You are not present in our database'
    end
  end
end
