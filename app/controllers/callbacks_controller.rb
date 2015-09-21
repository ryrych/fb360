class CallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token
  skip_before_action :authenticate_user!

  def google_oauth2
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)
    sign_in @user
    session[:user_id] = @user.id
    redirect_to root_path
  end
end
