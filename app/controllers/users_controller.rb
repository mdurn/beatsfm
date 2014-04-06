class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'application'

  def show
    @user = current_user
  end
end
