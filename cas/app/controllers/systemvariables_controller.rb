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
end