class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :require_admin

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all.order(:building_id, :number)
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @times = parse_available_time(@room.available_time)
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @buildings = Building.pluck(:name, :id)
    @buildings.delete_at(0)
  end

  # GET /rooms/1/edit
  def edit
    @buildings = Building.pluck(:name, :id)
    @buildings.delete_at(0)
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    if @room.save
      flash[:success] = 'Room was successfully added.'
      redirect_to rooms_path
    else
      render :new
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    if @room.update(room_params)
      flash[:success] = 'Room was successfully updated.'
      redirect_to rooms_path
    else
      render :edit 
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    flash[:success] = 'Room was successfully deleted.'
    rooms_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:number, :capacity, :building_id, :available_time)
    end
end
