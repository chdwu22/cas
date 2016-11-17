require 'rails_helper'

RSpec.describe "timeslots/edit", :type => :view do
  before(:each) do
    @timeslot = assign(:timeslot, Timeslot.create!(
      :day => "MyString",
      :from_time => 1,
      :to_time => 1
    ))
  end

  it "renders the edit timeslot form" do
    render

    assert_select "form[action=?][method=?]", timeslot_path(@timeslot), "post" do

      assert_select "input#timeslot_day[name=?]", "timeslot[day]"

      assert_select "input#timeslot_from_time[name=?]", "timeslot[from_time]"

      assert_select "input#timeslot_to_time[name=?]", "timeslot[to_time]"
    end
  end
end
