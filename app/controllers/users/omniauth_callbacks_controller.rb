class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authHash = request.env["omniauth.auth"]
    @user = User.find_for_facebook_oauth(authHash, current_user)
    
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = authHash
      redirect_to new_user_registration_url
    end
  end
end
