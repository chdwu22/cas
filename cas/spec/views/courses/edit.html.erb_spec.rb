require 'rails_helper'

RSpec.describe "courses/edit", :type => :view do
  before(:each) do
    @course = assign(:course, Course.create!(
      :number => "MyString",
      :section => "MyString",
      :name => "MyString",
      :size => 1,
      :day => "MyString",
      :time => "MyString",
      :year => 1,
      :semester => "MyString",
      :room_id => 1,
      :user_id => 1
    ))
  end

  it "renders the edit course form" do
    render

    assert_select "form[action=?][method=?]", course_path(@course), "post" do

      assert_select "input#course_number[name=?]", "course[number]"

      assert_select "input#course_section[name=?]", "course[section]"

      assert_select "input#course_name[name=?]", "course[name]"

      assert_select "input#course_size[name=?]", "course[size]"

      assert_select "input#course_day[name=?]", "course[day]"

      assert_select "input#course_time[name=?]", "course[time]"

      assert_select "input#course_year[name=?]", "course[year]"

      assert_select "input#course_semester[name=?]", "course[semester]"

      assert_select "input#course_room_id[name=?]", "course[room_id]"

      assert_select "input#course_user_id[name=?]", "course[user_id]"
    end
  end
end
