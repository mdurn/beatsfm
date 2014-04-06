class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def beats
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_beats_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is~
      set_flash_message(:notice, :success, :kind => "Beats") if is_navigational_format?
    else
      session["devise.beats_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end