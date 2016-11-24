class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?, :current_year, :current_semester, :format_time
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    !!current_user
  end
  
  def require_user
    if !logged_in?
      flash[:danger] = "You must log in to perform this action."
      redirect_to login_path
    end
  end
  
  def require_admin
    if logged_in? 
      if !current_user.is_admin?
        flash[:danger] = "You need admin right to visit this page."
        redirect_to user_path(current_user)
      end
    else
      flash[:danger] = "You need admin right to visit this page."
      redirect_to root_path
    end
  end
  
  def current_year
    Systemvariable.find_by(:name=>"scheduling_year").value
  end
  
  def current_semester
    Systemvariable.find_by(:name=>"scheduling_semester").value
  end
  
  def format_time(ts)
    time_slot = ts.split('-')
    ft = time_slot[0].to_i
    tt = time_slot[1].to_i
    start_min = (ft%100 ==0)? "00" : (ft%100).to_s
    end_min = (tt%100 ==0)? "00" : (tt%100).to_s
    (ft/100).to_s + ":" + start_min + "-" + (tt/100).to_s + ":" + end_min.to_s
  end
end
