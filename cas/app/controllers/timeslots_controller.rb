class TimeslotsController < ApplicationController
  before_action :set_timeslot, only: [:show, :edit, :update, :destroy]

  # GET /timeslots
  # GET /timeslots.json
  def index
    @timeslots = Timeslot.all
  end

  # GET /timeslots/1
  # GET /timeslots/1.json
  def show
  end

  # GET /timeslots/new
  def new
    @timeslot = Timeslot.new
  end

  # GET /timeslots/1/edit
  def edit
  end

  # POST /timeslots
  # POST /timeslots.json
  def create
    @timeslot = Timeslot.new(timeslot_params)

    respond_to do |format|
      if @timeslot.save
        format.html { redirect_to @timeslot, notice: 'Timeslot was successfully created.' }
        format.json { render :show, status: :created, location: @timeslot }
      else
        format.html { render :new }
        format.json { render json: @timeslot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timeslots/1
  # PATCH/PUT /timeslots/1.json
  def update
    respond_to do |format|
      if @timeslot.update(timeslot_params)
        format.html { redirect_to @timeslot, notice: 'Timeslot was successfully updated.' }
        format.json { render :show, status: :ok, location: @timeslot }
      else
        format.html { render :edit }
        format.json { render json: @timeslot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timeslots/1
  # DELETE /timeslots/1.json
  def destroy
    @timeslot.destroy
    respond_to do |format|
      format.html { redirect_to timeslots_url, notice: 'Timeslot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def new_time_table
    clear_records
    @days = Systemvariable.where(:name =>"day")
    @times = Systemvariable.where(:name =>"time")
    @days.each do |day|
      @times.each do |time|
        ts = time.value.split('-')
        ft = ts[0].to_i
        tt = ts[1].to_i
        @timeslot = Timeslot.new(:day=>day.value, :from_time=>ft, :to_time=>tt)
        @timeslot.save
      end
    end
    flash[:success] = "New time table has been generated."
    redirect_to root_path
  end
  
  def show_time_table
    @days = Timeslot.pluck(:day).uniq
    @times = Timeslot.pluck(:from_time, :to_time).uniq
    #@days = Systemvariable.where(:name =>"day")
    #@times = Systemvariable.where(:name =>"time")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timeslot
      @timeslot = Timeslot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timeslot_params
      params.require(:timeslot).permit(:day, :from_time, :to_time)
    end
    
    def clear_records
      @timeslots = Timeslot.all
      if !@timeslots.empty?
        @timeslots.each do |ts|
          ts.destroy
        end
      end
    end
end
