require 'rails_helper'

RSpec.describe "rooms/edit", :type => :view do
  before(:each) do
    @room = assign(:room, Room.create!(
      :number => 1,
      :capacity => 1,
      :building_id => 1
    ))
  end

  it "renders the edit room form" do
    render

    assert_select "form[action=?][method=?]", room_path(@room), "post" do

      assert_select "input#room_number[name=?]", "room[number]"

      assert_select "input#room_capacity[name=?]", "room[capacity]"

      assert_select "input#room_building_id[name=?]", "room[building_id]"
    end
  end
end
