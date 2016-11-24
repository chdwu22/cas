class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :require_admin
  before_action :set_courses, only: [:index, :assign_room, :set_course_time]

  # GET /courses
  # GET /courses.json
  def index
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
    @users = User.order(:last_name).pluck(:full_name, :id)
    @rooms = Room.order(:building_id).pluck(:number, :id)
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
      format.html { render :new }
      format.json { render json: @course.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    if @course.update(course_params)
      flash[:success] = 'Course was successfully updated.'
      redirect_to courses_path
    else
      format.html { render :edit }
      format.json { render json: @course.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    flash[:success] = 'Course was successfully deleted.'
    redirect_to courses_path
  end
  
  def assign_room
  end
  
  def set_course_time
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end
    
    def set_courses
      @courses = Course.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:number, :section, :name, :size, :day, :time, :year, :semester, :room_id, :user_id)
    end
end
