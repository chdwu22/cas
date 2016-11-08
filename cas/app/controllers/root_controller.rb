class RootController < ApplicationController
  def index
    if session[:user_id]==nil
      redirect_to login_path
    else
      user = User.find(session[:user_id])
      if user.is_admin?
        redirect_to users_path
      else
        redirect_to user_path(user)
      end
    end
  end
end