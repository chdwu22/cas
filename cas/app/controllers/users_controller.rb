class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :change_role]
  #before_action :require_user, except: [:new, :show]
  before_action :require_same_user, only: [:show, :edit, :update]
  before_action :require_admin, only:[:index, :destroy]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
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
    @user.destroy
    flash[:danger] = 'User was successfully deleted.'
    redirect_to users_url
  end
  
  def change_role
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
end
