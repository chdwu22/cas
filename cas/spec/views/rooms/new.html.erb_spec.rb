require 'rails_helper'

RSpec.describe "rooms/new", :type => :view do
  before(:each) do
    assign(:room, Room.new(
      :number => 1,
      :capacity => 1,
      :building_id => 1
    ))
  end

  it "renders new room form" do
    render

    assert_select "form[action=?][method=?]", rooms_path, "post" do

      assert_select "input#room_number[name=?]", "room[number]"

      assert_select "input#room_capacity[name=?]", "room[capacity]"

      assert_select "input#room_building_id[name=?]", "room[building_id]"
    end
  end
end
