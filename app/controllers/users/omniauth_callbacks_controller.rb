class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def beats
    @user = User.find_for_beats_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is~
      # set_flash_message(:notice, :success, :kind => "Beats") if is_navigational_format?
    else
      session["devise.beats_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def lastfm
    @user = current_user

    if @user.blank?
      flash[:alert] = 'Not Logged in. Sign in to continue.'
      redirect_to root_path
    else
      token = request.env["omniauth.auth"]['credentials']['token']
      username = request.env["omniauth.auth"]['credentials']['name']
      @user.set_lastfm_credentials!(username, token)
      redirect_to after_sign_in_path_for(@user)
    end
  rescue
    flash[:alert] = 'Unable to authenticate with Last.fm. Please try again'
    redirect_to root_path
  end
end