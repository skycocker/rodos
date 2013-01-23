class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authHash = request.env["omniauth.auth"]
    @user = User.find_for_facebook_oauth(authHash, current_user)
    
    def signInFromFacebook(user, authHash)
      session[:fb_access_token] = authHash["credentials"]["token"]
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    end
    
    if @user.persisted?
      signInFromFacebook(@user, authHash)
    elsif @existingUser = User.find_by_email(authHash["info"]["email"])
      @existingUser.update_attributes(provider: authHash["provider"], uid: authHash["uid"])
      
      @user = User.find_for_facebook_oauth(authHash, current_user)
      signInFromFacebook(@user, authHash)
    else
      session["devise.facebook_data"] = authHash
      redirect_to new_user_registration_url
    end
  end
end
