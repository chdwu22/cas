require 'rails_helper'

RSpec.describe "rooms/show", :type => :view do
  before(:each) do
    @room = assign(:room, Room.create!(
      :number => 1,
      :capacity => 2,
      :building_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
