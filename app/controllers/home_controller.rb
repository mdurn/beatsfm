class HomeController < ApplicationController

  layout 'application'

  def index
    redirect_to after_sign_in_path_for(current_user) if current_user.present?
  end
end
