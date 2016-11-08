require "rails_helper"

RSpec.feature "Faculty signup" do 
  scenario "Faculty sign up for account" do
    visit "/login"
    click_link "Sign up"
    
    expect(page).to have_content("Faculty sign up")
    expect(page.current_path).to eq(new_user_path) 
    
    fill_in "First name", with: "Nancy"
    fill_in "Last name", with: "Amato"
    fill_in "email name", with: "Amato@tamu.edu"
    fill_in "Password", with: "asdf"
    click_button "Sign up"
    expect(page).to have_content("Nancy Amato, you have successfully signed up")
    expect(page.current_path).to eq(user_path(:id => 1)) 
  end
end