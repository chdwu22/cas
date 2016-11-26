class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?, :current_year, :current_semester, :format_time, :format_day_time
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
    to_normal_time(ft) + "-" + to_normal_time(tt)
  end
  
  # convert integer mt = 800 to string nt = 8:00
  def to_normal_time(mt)
    hour = (mt/100).to_s
    min = (mt%100 ==0)? "00" : (mt%100).to_s
    return hour+":"+min
  end
  
  ##############################################################################
  #parse string "MW-800-1000, T-900-1500" to an array of daytime
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
        
        t = [days.upcase.scan(/\w/)] << start_time << end_time
        times << t
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
    if (end_time<=start_time || start_time >2400 || end_time >2400 || start_time%100>59 || end_time%100>59)
      flash[:danger] = "Check start time or end time format"
      return false
    else
      return true
    end
  end
  ##############################################################################
  
  #input is an array of daytime, [[["M","W"], 800, 1300],[["F"],930,1500]]. 
  #output is an array of string ["MW 8:00-13:00", "F 9:30-15:00"]
  def format_day_time(day_times)
    output = []
    day_times.each do |dt|
      str = ""
      dt[0].each { |d| str << d }
      str << " "
      str << to_normal_time(dt[1]) << "-" << to_normal_time(dt[2])
      output << str
    end
    return output
  end
  
  def remaining_time()
  end
  
  #convert [["T","R"],800,900] to 1920, 1980, 4800, 4860. T800 = (1*24+8)*60+0. 1 day 8 hours and 0 minute.
  def to_int_time(arr)
    result = []
    days = arr[0]
    days.each do |day|
      d = day_to_int(day)
      start_hour = Integer(arr[1])/100
      start_min = Integer(arr[1])%100
      end_hour = Integer(arr[2])/100
      end_min = Integer(arr[2])%100
      r1 = (d*24+start_hour)*60 + start_min
      r2 = (d*24 + end_hour)*60 + end_min
      result << r1 << r2
    end
    return result
  end
  
  def day_to_int(d)
    case d
    when "M", "m"
      return 0
    when "T", "t"
      return 1
    when "W", "w"
      return 2
    when "R", "r"
      return 3
    when "F", "f"
      return 4
    else
      return -1
    end
  end
  
  #return true if time2 is included in time1. [["T","R"],800,1000] includes [["T"],800,900]
  def include_time?(time1, time2)
    t1 = to_int_time(time1)
    t2 = to_int_time(time2)
    
    i=0
    while i < t2.count/2  do
      short_st = t2[i]
      short_et = t2[i+1]
      j=0
      while j < t1.count/2  do
        long_st = t1[j]
        long_et = t1[j+1]
        if(short_st < long_st || short_et > long_et)
          return false
        end
        j +=2
      end
      i +=2
    end
    return true
  end
  
  
  
  
  
  
end
