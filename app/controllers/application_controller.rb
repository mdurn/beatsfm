class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def after_sign_in_path_for(user)
    if user.lastfm_session_token.present?
      hitplay_path
    else
      user_omniauth_authorize_path(:lastfm)
    end
  end

  def after_sign_out_path_for(user)
    root_path
  end
end
