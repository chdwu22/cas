class PagesController < ApplicationController
  before_action :require_admin, only:[:admin_main]
  
  def root
    if session[:user_id]==nil
      redirect_to login_path
    else
      user = User.find(session[:user_id])
      if user.is_admin?
        redirect_to admin_main_path
      else
        redirect_to user_path(user)
      end
    end
  end
  
  def admin_main
    @faculty_permission = Systemvariable.find_by(:name=>"enable_faculty_edit?")
  end
end