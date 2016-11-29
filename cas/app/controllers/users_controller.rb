class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :change_role, :get_option]
  before_action :require_same_user, only: [:show, :edit, :update]
  before_action :require_admin, only:[:index, :destroy]
  helper_method :get_option
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    #general code
    ############################################################################
    # @days = Systemvariable.where("name=?","day")
    # @times = Systemvariable.where("name=?", "time")
    # #@days = Systemvariable.where(:name =>"day")
    # #@times = Systemvariable.where(:name =>"time")
    # @faculty_permission = Systemvariable.find_by(:name=>"enable_faculty_edit?")
    # @unacceptable_time_slot_limit = Systemvariable.find_by(:name=>"unacceptable_time_slot_limit")
    # @preferred_time_slot_limit =  Systemvariable.find_by(:name=>"preferred_time_slot_limit")
    # @timeslot_current_user = TimeslotUser.where("user_id=?", @user.id).includes(:timeslot)
    # #@timeslot_current_user = TimeslotUser.where(:user_id=>@user.id).includes(:timeslot)
    
    
    # if !@timeslot_current_user.empty?
    #   count=0
    #   order_matched_hash = {}
    #   @times.each do |t|
    #     ft = t.value.split('-')[0].to_i
    #     tt = t.value.split('-')[1].to_i
    #     @days.each do |d|
    #       @timeslot_current_user.each do |tcu|
    #         if(d.value == tcu.timeslot.day && ft==tcu.timeslot.from_time && tt == tcu.timeslot.to_time)
    #           order_matched_hash[count] = tcu.preference_type
    #           count += 1
    #         end
    #       end
    #     end
    #   end
      
    #   index = 0
    #   @preferences = []
    #   @times.each do |t|
    #     row = []
    #     @days.each do |d|
    #       row << order_matched_hash[index]
    #       index += 1
    #     end
    #     @preferences << row
    #   end
    # end
    #############################################################################
    
    #A&M CS code
    @faculty_permission = Systemvariable.find_by(:name=>"enable_faculty_edit?")
    @unacceptable_time_slot_limit = Systemvariable.find_by(:name=>"unacceptable_time_slot_limit")
    @preferred_time_slot_limit =  Systemvariable.find_by(:name=>"preferred_time_slot_limit")
    @user_pref = TimeslotUser.where("user_id=?", @user.id).includes(:timeslot)
    @MWF= Timeslot.where("day=?","MWF").order(:from_time)
    @MW= Timeslot.where("day=?","MW").order(:from_time)
    @TR= Timeslot.where("day=?","TR").order(:from_time)
    
    #course info
    courses = @user.courses
    @courses_info=[]
    if courses !=nil
      courses.each do |course|
        str = ""
        str << course.number << "-" << course.name << course.time
        if course.room!=nil
          str << course.room.building.name << course.room.number
        end
        @courses_info << str
      end
    end
    return @courses_info
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.full_name = @user.first_name + " " + @user.last_name
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'You have successfully signed up.'
      redirect_to @user
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      @user.full_name = @user.first_name + " " + @user.last_name
      @user.update(user_params)
      if !@user.is_admin
        redirect_to user_path(@user)
      else
      flash[:success] = "#{@user.full_name} was successfully updated."
        redirect_to users_path
      end
    else
      flash[:danger] = "Failed to add faculty."
      render :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @courses = Course.all
    @courses.each do |course|
      if(course.user_id = @user.id)
        course.user_id = 1
        course.save
      end
    end
    @user.destroy
    flash[:danger] = 'User was successfully deleted.'
    redirect_to users_url
  end
  
  def change_role
  end
  
  def assignment_by_faculty
    @users = User.all
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
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :full_name, :is_admin, :email, :password)
    end
    
    def require_same_user 
      if current_user != @user and !current_user.is_admin?
        flash[:danger] = "You have no permission to visit this page."
        redirect_to root_path
      end
    end
end
