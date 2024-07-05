class PasswordsController < Devise::PasswordsController
  skip_authorization_check only: %i[new create edit update]
end
