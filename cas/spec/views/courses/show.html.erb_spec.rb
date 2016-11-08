require 'rails_helper'

RSpec.describe "courses/show", :type => :view do
  before(:each) do
    @course = assign(:course, Course.create!(
      :number => "Number",
      :section => "Section",
      :name => "Name",
      :size => 1,
      :day => "Day",
      :time => "Time",
      :year => 2,
      :semester => "Semester",
      :room_id => 3,
      :user_id => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Number/)
    expect(rendered).to match(/Section/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Day/)
    expect(rendered).to match(/Time/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Semester/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
