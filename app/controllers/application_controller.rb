class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def after_sign_in_path_for(user)
    hitplay_path
  end

  def after_sign_out_path_for(user)
    root_path
  end
end
