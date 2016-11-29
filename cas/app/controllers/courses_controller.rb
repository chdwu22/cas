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
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    @course.year = current_year.to_i
    @course.semester = current_semester
    @course.room_id = 1
    @course.user_id = 1

    if @course.save
      flash[:success] = 'Course was successfully added.'
      redirect_to courses_path
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
    
    if(@timelines!=nil)
      radct = room_available_during_course_time?
      if(radct)
        if @course.update(course_params)
          flash[:success] = 'Course was successfully updated.'
          redirect_to courses_path
        else
          render :edit 
        end
      else
        flash[:danger] = "#{@room.building.name} #{@room.number} is not available during this class time"
        render :edit
      end
    else
      render :edit 
    end
    
    #if @course.update(course_params)
    #  flash[:success] = 'Course was successfully updated.'
    #  redirect_to courses_path
    #else
    #  render :edit
    #end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    flash[:success] = 'Course was successfully deleted.'
    redirect_to courses_path
  end
  
  def copy_courses
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
    
    def set_courses
      @courses = Course.where(year:current_year, semester: current_semester )
      #@courses = Course.where(:conditions=>["year=? and semester=?", current_year, current_semester])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:number, :section, :name, :size, :day, :time, :year, :semester, :room_id, :user_id)
    end
    
    def room_available_during_course_time?
      course_time = parse_available_time(course_params[:time])
      @room = Room.find(course_params[:room_id])
      
      if @room.id==1
        return true
      end
      if @room.available_time==nil
        flash[:danger] = "Available time for #{@room.building.name} #{@room.number} is not set"
        return false
      else
        if @room.available_time.empty?
          flash[:danger] = "Available time for #{@room.building.name} #{@room.number} is not set"
          return false
        end
      end
      #room_available_time = parse_available_time(@room.available_time)
      room_available_time = room_availability(@room)
      course_time.each do |ct|
        r = false
        room_available_time.each do |t|
          if include_time?(t, ct)
            r = true
          end
        end
        return r
      end
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
        if(course.room_id==room.id)
          if ct!=nil
            if !ct.empty?
              ra = subtract_time_group(ra,parse_available_time(ct))
            end
          end
        end
      end
      return ra
    end
    
    def render_edit
      @users = User.order(:last_name).pluck(:full_name, :id)
      @rooms = Room.order(:building_id, :number)
      @rooms_select = Room.where("capacity >= ?", @course.size).pluck(:id)
      @buildings = Building.pluck(:name, :id)
      timeslots = Timeslot.all
      @MWF= Timeslot.where("day=?","MWF").order(:from_time)
      @MW= Timeslot.where("day=?","MW").order(:from_time)
      @TR= Timeslot.where("day=?","TR").order(:from_time)
      @days = Systemvariable.where("name=?","day")
      @times = Systemvariable.where("name=?", "time")
      @user_pref = TimeslotUser.where("user_id=?", @course.user_id).includes(:timeslot)
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
