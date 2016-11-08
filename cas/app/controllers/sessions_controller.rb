class SessionsController < ApplicationController
   def new
   end
   
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user 
      if user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        flash[:success] = "Successfully logged in"
        if !user.is_admin
          redirect_to user_path(:id => user.id)
        else
          redirect_to users_path
        end
      else
        flash.now[:danger] = "Fail to log in."
        render :new
      end
    else
      flash.now[:danger] = "Fail to log in."
      render :new
    end
  end

   def destroy
      session[:user_id] = nil
      flash[:success] = "You have logged out"
      redirect_to root_path
   end
end