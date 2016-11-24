class TimeslotUsersController < ApplicationController
  before_action :set_user
  before_action :require_same_user
  
  def set_preference
    @prefs = paser_pref_params
    
    unacceptable_count = 0
    unacceptable_limit = Systemvariable.find_by(:name => "unacceptable_time_slot_limit").value.to_i
    @prefs.each{|k,v| unacceptable_count += 1 if v==3}
    
    preferred_count = 0
    preferred_limit = Systemvariable.find_by(:name => "preferred_time_slot_limit").value.to_i
    @prefs.each{|k,v| preferred_count += 1 if v==1}
    
    if (unacceptable_count > unacceptable_limit || preferred_count>preferred_limit)
      if unacceptable_count > unacceptable_limit
        flash[:danger] = "You have selected #{unacceptable_count} unacceptable time slots. The limit is #{unacceptable_limit}"
      end
      if preferred_count>preferred_limit
        flash[:danger] = "You have selected #{preferred_count} preferred time slots. The limit is #{preferred_limit}"
      end
    else
      @timeslot_current_user = TimeslotUser.where(:user_id=>@user.id)
      if !@timeslot_current_user.empty?
        @timeslot_current_user.each do |tcs|
          @prefs.each do |p|
            if(tcs.timeslot_id==p[0])
              tcs.preference_type = p[1]
              tcs.save
            end
          end
        end
      else
        @prefs.each do |p|
          TimeslotUser.create(:user_id=>@user.id, :timeslot_id=>p[0], :preference_type=>p[1])
        end
      end
      flash[:success] = "Preferences have successfully updated."
    end
    redirect_to user_path(@user)
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
    
  def paser_pref_params
    @timeslots = Timeslot.all
    timeslot_user = {}
    params.each do |param|
      if param.to_s.include? "pref"
        p = param.split('-')
        day = p[1]
        start_time = p[2].to_i
        end_time = p[3].to_i
        @timeslots.each do |ts|
          if(day==ts.day && start_time==ts.from_time && end_time==ts.to_time)
            timeslot_user[ts.id] = params[param].to_i
          end
        end
      end
    end
    return timeslot_user
  end
end