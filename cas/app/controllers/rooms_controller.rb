class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :require_admin

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all.order(:number)
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    if (@room.available_time!=nil)
      if(!@room.available_time.strip.empty?)
        @times = parse_available_time(@room.available_time)
      end
    end
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    availability = false
    if (@room.available_time!=nil)
      if(!@room.available_time.strip.empty?)
        availability = true
        @times = parse_available_time(@room.available_time)
      end
    end
    
    if(availability==true && @times==nil)
      render :new
      return
    else
      if @room.save
        flash[:success] = 'Room was successfully added.'
        redirect_to rooms_path
      else
        render :new
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    if (room_params[:available_time]!=nil)
      if(!room_params[:available_time].strip.empty?)
        @times = parse_available_time(room_params[:available_time])
      end
    end
    
    if(@times!=nil)
      if @room.update(room_params)
        flash[:success] = 'Room was successfully updated.'
        redirect_to rooms_path
      else
        render :edit 
      end
    else
      flash.now[:danger] = 'Available time is empty.'
      render :edit 
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @courses = Course.all
    @courses.each do |course|
      if(course.room_id == @room.id)
        course.room_id =1
        course.save
      end
    end
    @room.destroy
    flash[:success] = 'Room was successfully deleted.'
    redirect_to rooms_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:number, :capacity, :available_time)
    end
end
