require 'rails_helper'

RSpec.describe "timeslots/show", :type => :view do
  before(:each) do
    @timeslot = assign(:timeslot, Timeslot.create!(
      :day => "Day",
      :from_time => 1,
      :to_time => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Day/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
