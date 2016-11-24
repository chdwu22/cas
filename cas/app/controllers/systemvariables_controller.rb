class SystemvariablesController < ApplicationController
  before_action :require_admin
  
  def get_current_semester
  end
  
  def set_current_semester
    @year = Systemvariable.find_by(:name =>"scheduling_year")
    @semester = Systemvariable.find_by(:name =>"scheduling_semester")
    @year.value = params[:year]
    @semester.value = params[:semester]
    @year.save
    @semester.save
    redirect_to root_path
  end
  
  def new_day
    @days = Systemvariable.where(:name =>"day")
  end
  
  def create_day
    day = Systemvariable.find_by(:value =>params[:day])
    if day==nil
      @day = Systemvariable.new(:name=>"day", :value=>params[:day])
      @day.save
      redirect_to new_day_path
    else
      flash[:danger] = "#{params[:day]} already exists"
      redirect_to new_day_path
    end
  end
  
  def delete_day
    @day = Systemvariable.find(params[:id])
    @day.destroy
    redirect_to new_day_path
  end
  
  def new_time
    @times = Systemvariable.where(:name =>"time")
  end
  
  def create_time
    if !overlapping?
      new_time_slot = params[:from_time]+'-'+params[:to_time]
      @time = Systemvariable.new(:name=>"time", :value=>new_time_slot)
      @time.save
      redirect_to new_time_path
    else
      flash[:danger] = "#{params[:time]} overlaps existing time slot"
      redirect_to new_time_path
    end
  end
  
  def delete_time
    @time = Systemvariable.find(params[:id])
    @time.destroy
    redirect_to new_time_path
  end
  
  def overlapping?
    @times = Systemvariable.where(:name =>"time")
    return false if @times.empty?
    new_from_time = params[:from_time].to_i
    new_to_time = params[:to_time].to_i
    @times.each do |time|
      time_slot = time.value.split('-')
      existing_from_time = time_slot[0].to_i
      existing_to_time = time_slot[1].to_i
      return true if (inside?(existing_from_time, existing_to_time, new_from_time) || 
                      inside?(existing_from_time, existing_to_time, new_to_time) ||
                      inside?(new_from_time, new_to_time, existing_from_time) ||
                      new_from_time==existing_from_time || new_to_time==existing_to_time)
    end
    return false
  end
  
  #check if a specific point in time, target, is in between a time frame, from-to.
  def inside?(from, to, target)
    target > from && target < to
  end
  
  def faculty_edit_permission
    @faculty_permission = Systemvariable.find_by(:name=>"enable_faculty_edit?")
  end
  
  def set_faculty_permission
    @faculty_permission = Systemvariable.find_by(:name=>"enable_faculty_edit?")
    @faculty_permission.value=params[:fac_perm]
    if @faculty_permission.save!
      if @faculty_permission.value=="yes"
        flash[:success] = "ENABLED faculty to change preferences."
      else
        flash[:success] = "DISABLED faculty to change preferences."
      end
      redirect_to root_path
    end
  end
  
  def unacceptable_time_slot_limit
    @unacceptable_time_slot_limit = Systemvariable.find_by(:name=>"unacceptable_time_slot_limit")
  end
  
  def set_unacceptable_limit
    @unacceptable_time_slot_limit = Systemvariable.find_by(:name=>"unacceptable_time_slot_limit")
    @unacceptable_time_slot_limit.value = params[:limit]
    @unacceptable_time_slot_limit.save
    flash[:success] = "New limit has set to #{@unacceptable_time_slot_limit.value}"
    redirect_to unacceptable_time_slot_limit_path
  end
  
  def preferred_slot_limit
    @preferred_slot_limit = Systemvariable.find_by(:name=>"preferred_time_slot_limit")
  end
  
  def set_preferred_limit
    @preferred_slot_limit = Systemvariable.find_by(:name=>"preferred_time_slot_limit")
    @preferred_slot_limit.value = params[:limit]
    @preferred_slot_limit.save
    flash[:success] = "New limit has set to #{@preferred_slot_limit.value}"
    redirect_to preferred_time_slot_limit_path
  end
end