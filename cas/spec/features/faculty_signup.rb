require "rails_helper"

RSpec.feature "Faculty signup" do 
  scenario "Faculty sign up for account" do
    visit "/login"
    click_link "Sign up"
    
    expect(page).to have_content("Sign-up")
    expect(page.current_path).to eq(new_user_path) 
    
    fill_in "First name", with: "Nancy"
    fill_in "Last name", with: "Amato"
    fill_in "Email", with: "Amato@tamu.edu"
    fill_in "Password", with: "asdf"
    click_button "Create User"
    expect(page).to have_content("Nancy Amato")
    expect(page).to have_content("You have successfully signed up")
    expect(page.current_path).to eq(user_path(:id => 1)) 
  end
  
  scenario "Faculty sign up for account" do
    visit "/login"
    
    fill_in "Email", with: "Amato@tamu.edu"
    fill_in "Password", with: "asdf"
    click_button "Log in"
    expect(page).to have_content("Nancy Amato")
    expect(page).to have_content("Successfully logged up")
    expect(page.current_path).to eq(user_path(:id => 1)) 
  end
end