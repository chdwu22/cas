require 'rails_helper'

RSpec.describe "rooms/index", :type => :view do
  before(:each) do
    assign(:rooms, [
      Room.create!(
        :number => 1,
        :capacity => 2,
        :building_id => 3
      ),
      Room.create!(
        :number => 1,
        :capacity => 2,
        :building_id => 3
      )
    ])
  end

  it "renders a list of rooms" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
