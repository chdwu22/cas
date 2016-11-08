require 'rails_helper'

RSpec.describe "users/edit", :type => :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :first_name => "MyString",
      :last_name => "MyString",
      :full_name => "MyString",
      :is_admin => false,
      :email => "MyString",
      :password_digest => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input#user_first_name[name=?]", "user[first_name]"

      assert_select "input#user_last_name[name=?]", "user[last_name]"

      assert_select "input#user_full_name[name=?]", "user[full_name]"

      assert_select "input#user_is_admin[name=?]", "user[is_admin]"

      assert_select "input#user_email[name=?]", "user[email]"

      assert_select "input#user_password_digest[name=?]", "user[password_digest]"
    end
  end
end
