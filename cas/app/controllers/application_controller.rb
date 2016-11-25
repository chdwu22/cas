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
  
  #format string 800 to 8:00
  def format_time(ts)
    time_slot = ts.split('-')
    ft = time_slot[0].to_i
    tt = time_slot[1].to_i
    start_min = (ft%100 ==0)? "00" : (ft%100).to_s
    end_min = (tt%100 ==0)? "00" : (tt%100).to_s
    (ft/100).to_s + ":" + start_min + "-" + (tt/100).to_s + ":" + end_min.to_s
  end
  
  ##############################################################################
  #parse string "MW-0800-1000, T-900-1500" to an array of datetime
  def parse_available_time(input_str)
    times = []
    begin
      lines = input_str.split(',')
      lines.each do |line|
        cells = line.strip.split('-')
        return nil if !legit_cells?(cells)
        
        days = cells[0].delete(' ')
        return nil if !legit_days?(days)
        
        start_time = Integer(cells[1].strip)
        end_time = Integer(cells[2].strip)
        return nil if !legit_time?(start_time, end_time)
        
        times << days.scan(/\w/) << start_time << end_time
      end
    rescue
      flash[:danger] = "Time format not correct."
      return nil
    else
      return times
    end
  end
  
  def legit_cells?(cells)
    if(cells.count >3)
      flash[:danger] = "Check if missing comma between lines"
      return false
    elsif (cells.count < 3)
      flash[:danger] = "Check if missing dash between day, start time, end time"
      return false
    else
      return true
    end
  end
  
  def legit_days?(days)
    if ("MTWRFmtwrf".count(days) == days.size) 
      return true
    else
      flash[:danger] = "Check if day is not Monday through Friday"
      return false
    end
  end
  
  def legit_time?(start_time, end_time)
    if (end_time<=start_time || start_time >2400 || end_time >2400)
      flash[:danger] = "Check start time and end time format"
      return false
    else
      return true
    end
  end
  ##############################################################################
end
