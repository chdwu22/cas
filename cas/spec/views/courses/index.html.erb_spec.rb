require 'rails_helper'

RSpec.describe "courses/index", :type => :view do
  before(:each) do
    assign(:courses, [
      Course.create!(
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
      ),
      Course.create!(
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
      )
    ])
  end

  it "renders a list of courses" do
    render
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => "Section".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Day".to_s, :count => 2
    assert_select "tr>td", :text => "Time".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Semester".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
