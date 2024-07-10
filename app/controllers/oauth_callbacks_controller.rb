class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def github
    sign_in_user
  end

  def vkontakte
    sign_in_user
  end

  private

  def sign_in_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      redirect_unconfirmed_user unless @user.confirmed?
      sign_in_and_redirect @user, event: :authentication

      set_flash_message(:notice, :success, kind: action_name.capitalize.to_s) if is_navigational_format?
    else
      session[:oauth_provider] = request.env['omniauth.auth']['provider']
      session[:oauth_uid] = request.env['omniauth.auth']['uid']

      redirect_to new_user_path
    end
  end

  def redirect_unconfirmed_user
    redirect_to new_user_session_path, alert: 'You have to confirm your email address'
  end
end
