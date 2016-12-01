class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :schedule_course]
  before_action :require_admin
  before_action :set_courses, only: [:index, :assign_room, :set_course_time]
  before_action :render_edit, only: [:edit, :update]
  
  helper_method :room_availability, :get_option

  # GET /courses
  # GET /courses.json
  def index
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    if (@course.time!=nil)
      if(!@course.time.strip.empty?)
        @timelines = parse_available_time(@course.time)
      end
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
    @course_repo = Course.where("year=?",0).order(:number)
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
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
  def update
    #check if user entered time is legit format
    if (course_params[:time]!=nil)
      if(!course_params[:time].strip.empty?)
        @timelines = parse_available_time(course_params[:time])
      end
    end
    
    user = User.find(course_params[:user_id])
    if(@timelines!=nil)
      radct = room_available_during_course_time?
      fto = faculty_time_overlap?
      if(radct && !fto)
        if @course.update(course_params)
          flash[:success] = 'Course was successfully updated.'
          redirect_to edit_course_path(@course)
        else
          render :edit 
        end
      else
        if !radct
          flash.now[:danger] = "#{@room.number} is not available during this class time"
          render :edit
        end
        if fto
          flash.now[:danger] = "#{user.full_name} has another class scheduled at this time"
          render :edit
        end
      end
    else
      render :edit 
    end
  end
  
  def room_available_during_course_time?
    course_time = parse_available_time(course_params[:time])
    @room = Room.find(course_params[:room_id])
    
    if @room.id==1
      return true
    end
    if @room.available_time==nil
      flash[:danger] = "Available time for #{@room.number} is not set"
      return false
    else
      if @room.available_time.empty?
        flash[:danger] = "Available time for #{@room.number} is not set"
        return false
      end
    end
    #room_available_time = parse_available_time(@room.available_time)
    room_available_time = room_availability(@room)
    
    r = false
    room_available_time.each do |t|
      if include_time?(t, course_time[0])
        r = true
      end
    end
    return r
  end
  
  def faculty_time_overlap?
    course_id = course_params[:id]
    user_id = course_params[:user_id]
    user = User.find(user_id)
    if user_id.to_i==1
      return false
    end
    faculty_courses = user.courses
    faculty_courses.each do |fc|
      f_time = fc.time.split('-')
      c_time = course_params[:time].split('-')
      if(course_id != fc.id)
        if(f_time[0][0]==c_time[0][0] && f_time[1]==c_time[1])
          return true
        end
      end
    end
    return false
  end
  
  
  def room_availability(room)
    if (room.available_time==nil || room.id==1)
      return nil
    end
    if room.available_time.empty?
      return nil
    end
    ra = parse_available_time(room.available_time)
    @courses = set_courses
    @courses.each do |course|
      ct = course.time
      if(course.room_id==room.id && course.id!=@course.id)
        if ct!=nil
          if !ct.empty?
            ra = subtract_time_group(ra,parse_available_time(ct))
          end
        end
      end
    end
    return ra
  end
    

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    flash[:success] = "#{@course.number} was successfully deleted."
    redirect_to :back
  end
  
  def delete_course_repo
    @course = Course.find(params[:id])
    @course.destroy
    flash[:success] = "#{@course.number} was successfully deleted."
    redirect_to new_course_path
  end
  
  def get_course_repo
    @course_repo = Course.where("year=?",0).order(:number)
    @current_courses = set_courses
  end
  
  def add_to_current_courses
    #@current_courses = set_courses
    @course_repo = Course.where("year=?",0).order(:number)
    origin_course = Course.find(params[:id])
    # @current_courses.each do |cc|
    #   if cc.number == origin_course.number
    #     flash.now[:danger] = "#{origin_course.number} was already added"
    #     render :get_course_repo
    #     return
    #   end
    # end
    
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
    
    def set_courses
      @courses = Course.where(year: current_year, semester: current_semester ).order(:number)
      #@courses = Course.where(:conditions=>["year=? and semester=?", current_year, current_semester])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:number, :section, :name, :size, :day, :time, :year, :semester, :room_id, :user_id)
    end
    
    def render_edit
      @users = User.order(:last_name).pluck(:full_name, :id)
      @rooms = Room.where("capacity >= ?", @course.size).order(:capacity)
      @courses = Course.where(year:current_year, semester: current_semester ).order(:number)
      @rooms_select = Room.where("capacity >= ?", @course.size).pluck(:number, :id)
      @buildings = Building.pluck(:name, :id)
      timeslots = Timeslot.all
      @MWF= Timeslot.where("day=?","MWF").order(:from_time)
      @MW= Timeslot.where("day=?","MW").order(:from_time)
      @TR= Timeslot.where("day=?","TR").order(:from_time)
      @days = Systemvariable.where("name=?","day")
      @times = Systemvariable.where("name=?", "time")
      @user_pref = TimeslotUser.where("user_id=?", @course.user_id).includes(:timeslot)
      @assigned_courses=[]
      @timeslots = []
      timeslots.each do |ts|
        str = ts.day + "-" + ts.from_time.to_s + "-" + ts.to_time.to_s
        @timeslots << str
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
