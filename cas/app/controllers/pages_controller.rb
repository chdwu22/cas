class PagesController < ApplicationController
  before_action :require_admin, except: [:root]
  before_action :get_data, only: [:getcourse, :assignment_table]
  
  helper_method :get_unassigned_courses
  
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
  
  def assignment_table
  end
  
  def get_data
    @courses = Course.where(year:current_year, semester: current_semester ).order(:number)
    @rooms = Room.all.order(:number)
    @users = User.all
    @timeslots = Timeslot.all
    @assigned_courses=[]
  end
  
  
end