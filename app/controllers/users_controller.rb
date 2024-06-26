class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create_user
    email = params[:user][:email]
    password = Devise.friendly_token[0, 20]
    @user = User.new(email: email, password: password, password_confirmation: password)

    if @user.save
      confirm_email_for(@user)
    else
      render :new
    end
  end

  private

  def confirm_email_for(user)
    user.authorizations.create(provider: session[:oauth_provider], uid: session[:oauth_uid])

    session.delete %i[oauth_provider oauth_uid]

    user.send_confirmation_instructions
    redirect_to root_path, alert: 'You receive email with instructions for how to confirm your email address soon'
  end
end
