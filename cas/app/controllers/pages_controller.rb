class PagesController < ApplicationController
  before_action :require_admin, only:[:admin_main]
  before_action :get_data, only: [:getcourse, :assignment_table]
  
  helper_method :get_course, :get_preference
  
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
  
  def get_course(room, mtwrf)
    @courses.each do |course|
      if course.time!=nil
        arr = course.time.split('-')
        day = arr[0]
        from_time = arr[1].to_i
        if(course.room_id == room.id && day==mtwrf.day && from_time == mtwrf.from_time)
          return course
        end
      end 
    end
    return nil
  end
  
  def get_preference(course, mtwrf)
    if course!=nil
      if course.user_id != 1
        pref = TimeslotUser.where("user_id=?",course.user_id).includes(:timeslot)
        if pref != nil
          pref.each do |p|
            if (p.timeslot.day == mtwrf.day && p.timeslot.from_time == mtwrf.from_time)
              return p.preference_type
            end
          end
        else
          return 2
        end
      else
        return 2
      end
    else
      return 2
    end
  end
  
  def get_data
    @courses = Course.all
    @rooms = Room.all.order(id: :desc)
    @users = User.all
    @MWF= Timeslot.where("day=?","MWF").order(:from_time)
    @MW= Timeslot.where("day=?","MW").order(:from_time)
    @TR= Timeslot.where("day=?","TR").order(:from_time)
  end
  
  
end