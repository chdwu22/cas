require 'rails_helper'

RSpec.describe "buildings/new", :type => :view do
  before(:each) do
    assign(:building, Building.new(
      :name => "MyString"
    ))
  end

  it "renders new building form" do
    render

    assert_select "form[action=?][method=?]", buildings_path, "post" do

      assert_select "input#building_name[name=?]", "building[name]"
    end
  end
end
