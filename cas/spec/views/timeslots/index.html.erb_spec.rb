require 'rails_helper'

RSpec.describe "timeslots/index", :type => :view do
  before(:each) do
    assign(:timeslots, [
      Timeslot.create!(
        :day => "Day",
        :from_time => 1,
        :to_time => 2
      ),
      Timeslot.create!(
        :day => "Day",
        :from_time => 1,
        :to_time => 2
      )
    ])
  end

  it "renders a list of timeslots" do
    render
    assert_select "tr>td", :text => "Day".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
