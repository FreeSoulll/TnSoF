class RegistrationsController < Devise::RegistrationsController
  skip_authorization_check only: %i[new create cancel]
end
