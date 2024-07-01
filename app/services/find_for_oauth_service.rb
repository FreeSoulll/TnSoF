class FindForOauthService
  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: @auth.provider, uid: @auth.uid.to_s).first
    return authorization.user if authorization

    email = @auth.info[:email]

    if email
      find_or_create_user_by_email(email)
    else
      User.new
    end
  end

  private

  def find_or_create_user_by_email(email)
    user = User.where(email: email).first

    if user
      user.create_authorization(@auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.now)
      user.create_authorization(@auth)
    end

    user
  end
end
