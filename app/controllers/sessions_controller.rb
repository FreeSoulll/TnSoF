class SessionsController < Devise::SessionsController
  skip_authorization_check only: %i[new create destroy]
end
