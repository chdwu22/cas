class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :schedule_course]
  before_action :require_admin
  before_action :set_courses, only: [:index, :update, :assign_room, :set_course_time, :delete_all_courses, :auto_schedule]
  before_action :render_edit, only: [:edit, :update]
  
  helper_method :room_availability, :get_option

  # GET /courses
  # GET /courses.json
  #############################################################################
  def index
  end

  # GET /courses/1
  # GET /courses/1.json
  #############################################################################
  def show
    if (@course.time!=nil)
      if(!@course.time.strip.empty?)
        @timelines = parse_available_time(@course.time)
      end
    end
  end

  # GET /courses/new
  #############################################################################
  def new
    @course = Course.new
    @course_repo = Course.where("year=?",0).order(:number)
  end

  # GET /courses/1/edit
  #############################################################################
  def edit
  end

  # POST /courses
  # POST /courses.json
  #############################################################################
  def create
    @course = Course.new(course_params)
    @course.year = 0
    @course.room_id = 1
    @course.user_id = 1

    if @course.save
      flash[:success] = 'Course was successfully added.'
      redirect_to new_course_path
    else
      render :new
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  #############################################################################
  def update
    #check if user entered time is legit format
    if (course_params[:time]!=nil)
      if(!course_params[:time].strip.empty?)
        @timelines = parse_available_time(course_params[:time])
      end
    end
    
    user = User.find(course_params[:user_id])
    if(@timelines!=nil)
      room = Room.find(course_params[:room_id])
      if room.capacity < course_params[:size].to_i
        flash.now[:danger] = "Course size is set to greater than the room capacity."
        render :edit
        return
      end
      radct = room_available_during_course_time?(room, course_params[:time], @courses, @course)
      fto = faculty_time_overlap?
      if(radct && !fto)
        if @course.update(course_params)
          flash[:success] = 'Course was successfully updated.'
          redirect_to edit_course_path(@course)
        else
          render :edit 
          return
        end
      else
        if !radct
          flash.now[:danger] = "#{room.number} is not available during this class time"
          render :edit
          return
        end
        if fto
          flash.now[:danger] = "#{user.full_name} has another class scheduled at this time"
          render :edit
          return
        end
      end
    else
      render :edit 
      return
    end
  end
  
  #############################################################################
  def room_available_during_course_time?(room, new_course_time, courses, current_course)
    ct = parse_available_time(new_course_time)
    
    if room.id==1
      return true
    end
    if room.available_time==nil
      flash[:danger] = "Available time for #{room.number} is not set"
      return false
    else
      if room.available_time.empty?
        flash[:danger] = "Available time for #{room.number} is not set"
        return false
      end
    end
    #room_available_time = parse_available_time(room.available_time)
    room_available_time = room_availability(room, courses, current_course)
    room_available_time.each do |t|
      if include_time?(t, ct[0])
        return true
      end
    end
    return false
  end
  
  #############################################################################
  def faculty_time_overlap?
    user_id = course_params[:user_id].to_i
    user = User.find(user_id)
    if user_id==1
      return false
    end
    faculty_courses = user.courses
    faculty_courses.each do |fc|
      f_time = fc.time.split('-')
      c_time = course_params[:time].split('-')
      if(@course.id != fc.id)
        if(f_time[0][0]==c_time[0][0] && f_time[1]==c_time[1])
          return true
        end
      end
    end
    return false
  end
  
  #############################################################################
  def room_availability(room, courses, current_course)
    if (room.available_time==nil || room.id==1)
      return nil
    end
    if room.available_time.empty?
      return nil
    end
    ra = parse_available_time(room.available_time)
    courses.each do |course|
      ct = course.time
      if(course.room_id==room.id && course.id!=current_course.id)
        if ct!=nil
          if !ct.empty?
            ra = subtract_time_group(ra,parse_available_time(ct))
          end
        end
      end
    end
    return ra
  end
  
  #############################################################################  
  def copy_courses
    previous_year = params[:previous_year]
    previous_semester = params[:previous_semester]
    courses = Course.where(:year=>previous_year, :semester=>previous_semester)
    if courses!=nil
      if !courses.empty?
        courses.each do |course|
          Course.create(:number=>course.number, :name=>course.name, :size=>course.size, 
                        :time=>course.time, :year=>current_year, :semester=>current_semester,
                        :room_id=>course.room_id, :user_id=>course.user_id)
        end
        flash[:success] = "Courses from #{previous_year} #{previous_semester} are successfully copied."
      else
        flash[:danger] = "#{previous_year} #{previous_semester} does not have courses."
      end
    else
      flash[:danger] = "#{previous_year} #{previous_semester} does not have courses."
    end
    
    redirect_to get_course_repo_path
  end
  
  # DELETE /courses/1
  # DELETE /courses/1.json
  #############################################################################
  def destroy
    @course.destroy
    flash[:success] = "#{@course.number} was successfully deleted."
    redirect_to :back
  end
  
  #############################################################################
  def delete_course_repo
    @course = Course.find(params[:id])
    @course.destroy
    flash[:success] = "#{@course.number} was successfully deleted."
    redirect_to new_course_path
  end
  
  #############################################################################
  def delete_all_courses
    @courses.each do |course|
      course.destroy
    end
    flash[:success] = "All current semester courses are deleted."
    redirect_to get_course_repo_path
  end
  
  #############################################################################
  def get_course_repo
    @course_repo = Course.where("year=?",0).order(:number)
    @current_courses = set_courses
    @year = Systemvariable.find_by(:name =>"scheduling_year")
    @semester = Course.where.not(:year=>0).pluck(:semester).uniq
  end
  
  #############################################################################
  def add_to_current_courses
    @course_repo = Course.where("year=?",0).order(:number)
    origin_course = Course.find(params[:id])
    
    @course = Course.new
    @course.number = origin_course.number
    @course.name = origin_course.name
    @course.size = 0
    @course.year = Systemvariable.find_by(:name=> "scheduling_year").value.to_i
    @course.semester = Systemvariable.find_by(:name=> "scheduling_semester").value
    @course.room_id = 1
    @course.user_id = 1

    if @course.save
      flash[:success] = "#{@course.number} was successfully added."
      redirect_to get_course_repo_path
    else
      render :get_course_repo
    end
  end
  
  #############################################################################
  def enough_rooms
    @rooms = Room.all.order(capacity: :desc)
    @courses = Course.where(year: current_year, semester: current_semester ).order(:size=> :desc)
    @timeslots = Timeslot.all
    room_timeslots = []  #[100,100,100,50,50,50,50,30] means that there are 
                          # three timelots with room capacity of 100, and so on.
                          # In descent order of capacity.
    @rooms.each do |room|
      mw = [0,0]
      tr = [0,0]
      if room.id ==1
        next
      end
      rats = room.available_time
      arr_rat = parse_available_time(rats)
      arr_rat.each do |rt|
        @timeslots.each do |ts|
          arr_ts = timeslot_to_array_time(ts)
          if include_time?(rt, arr_ts)
            if ts.from_time < 1700
              room_timeslots << room.capacity
            else
              if ts.day == "MW"
                mw[0] += 1
              elsif ts.day =="M" || ts.day=="W"
                mw[1] += 1
              elsif ts.day =="TR"
                tr[0] += 1
              elsif ts.day == "T" || ts.day == "R"
                tr[1] += 1
              end
            end
          end
        end
        max_mw = (mw[0] > mw[1]) ? mw[0] : mw[1]
        max_tr = (tr[0] > tr[1]) ? tr[0] : tr[1]
        for i in 1..max_mw
          room_timeslots << room.capacity
        end
        for i in 1..max_tr
          room_timeslots << room.capacity
        end
      end
    end
    
    @courses_no_room = []
    @courses_size_not_set = []
    @courses.each do |course|
      if course.size == 0
        @courses_size_not_set << course
        next
      end
      if course.size <= room_timeslots[0]
        room_timeslots.delete_at(0)
        next
      else
        @courses_no_room << course
      end
    end
    
    if @courses_no_room.empty? && @courses_size_not_set.empty?
      flash[:success] = "Rooms are enough."
      redirect_to courses_path
    elsif !@courses_no_room.empty?
      flash.now[:danger] = "NOT enough rooms."
    elsif @courses_size_not_set.count > room_timeslots.count
      shortage = @courses_size_not_set.count + @courses_no_room.count - room_timeslots.count
      flash.now[:danger] = "NOT enough rooms. Needs at least #{shortage} more time slots"
    else
      flash.now[:success] = "Rooms might be enough."
    end
  end
  
  #############################################################################
  def auto_schedule
    count = 0
    @courses = Course.where(year: current_year, semester: current_semester ).order(:size=> :desc).includes(:user)
    rooms = Room.where.not("id=?",1).order(capacity: :desc)
    timeslots = Timeslot.all
    @rooms_availability = {}
    rooms.each do |room|
      values = []
      availability = room.available_time
      if availability!=nil
        arr_avail = parse_available_time(availability)
        arr_avail.each do |rat|
          timeslots.each do |ts|
            arr_ts = timeslot_to_array_time(ts)
            if include_time?(rat, arr_ts)
              values<< ts.id
            end
          end
        end
      end
      if !values.empty?
        @rooms_availability.store(room.id, values)
      end
    end
    
    
    courses_faculty_notset = []
    @courses.each do |course|
      @course=course
      if course.size == 0
        next
      end
      if course.user_id==1
        courses_faculty_notset << course
        next
      end
      
      faculty = course.user
      preferred = faculty.timeslot_users.where(preference_type: 1)
      acceptable = faculty.timeslot_users.where(preference_type: 2)
      capable_rooms = rooms.select{ |room| room.capacity >= course.size }
      if capable_rooms.empty?
        next
      end
      
      preferred_timeslots=[]
      acceptable_timeslots=[]
      preferred.each { |p| preferred_timeslots << p.timeslot }
      acceptable.each { |a| acceptable_timeslots << a.timeslot }
      
      if set_time_and_room(preferred_timeslots, capable_rooms)
        count += 1
        next
      else
        if set_time_and_room(acceptable_timeslots, capable_rooms)
          count += 1
        end
      end
    end
    
    courses_faculty_notset.each do |course|
      @course=course
      capable_rooms = rooms.select{ |room| room.capacity >= course.size }
      if capable_rooms.empty?
        next
      end
      if set_time_and_room(timeslots, capable_rooms)
        count += 1
        next
      end
    end
    
    flash[:success] = "#{count} classes are scheduled."
    redirect_to assignment_table_path
  end
  
  #############################################################################
  def set_time_and_room(timeslots, capable_rooms)
    capable_rooms.each do |room|
      timeslots.each do |ts|
        room_times = @rooms_availability[room.id]
        room_times.each do |rt|
          if ts.id == rt
            @course.room_id = room.id
            @course.time = timeslot_to_string(ts)
            @course.save
            @rooms_availability[room.id].delete(rt)
            return true
          end
        end
      end
    end
    return false
  end
  
  ##############################################################################
  def timeslot_to_string(ts)
    return ts.day+"-"+ts.from_time.to_s+"-"+ts.to_time.to_s
  end
  #############################################################################
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
    
    def set_courses
      @courses = Course.where(year: current_year, semester: current_semester ).order(:number)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:number, :section, :name, :size, :day, :time, :year, :semester, :room_id, :user_id)
    end
    
    def render_edit
      @users = User.order(:last_name).pluck(:full_name, :id)
      @rooms = Room.where("capacity >= ?", @course.size).order(:number)
      @courses = Course.where(year: current_year, semester: current_semester ).order(:number)
      @rooms_select = Room.where("capacity >= ?", @course.size).pluck(:number, :id)
      @timeslots = Timeslot.all
      @days = Timeslot.pluck(:day).uniq
      @user_pref = TimeslotUser.where("user_id=?", @course.user_id).includes(:timeslot)
      @assigned_courses=[]
      
      @stringtimeslots = []
      @timeslots.each do |ts|
        str = ts.day + "-" + ts.from_time.to_s + "-" + ts.to_time.to_s
        @stringtimeslots << str
      end
    end
    
    def get_option(mw)
      @user_pref.each do |up|
        if (up.timeslot.day == mw.day && up.timeslot.from_time == mw.from_time)
          option = "A"
          if(up.preference_type==1)
            option = "P"
          elsif (up.preference_type==3)
            option = "U"
          end
          return [up.preference_type,option]
        end
      end
    end
  
  
    
    
    
    
    
  
end
