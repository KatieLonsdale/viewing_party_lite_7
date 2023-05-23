require 'rails_helper'

RSpec.describe "landing page" do
  describe "as a user, when I visit the landing page" do
    before(:each) do
      @user_1 = User.create!(name: "Katie", email: "email_address@gmail.com", password: "test123", password_confirmation: "test123")
      @user_2 = User.create!(name: "Steve", email: "email_address_2@gmail.com", password: "test123", password_confirmation: "test123")
      @user_3 = User.create!(name: "Stacey", email: "email_address_3@gmail.com", password: "test123", password_confirmation: "test123")
      @users = [@user_1, @user_2, @user_3]
      visit root_path
    end
    it "displays the title of the application" do
      within("#title") do
        expect(page).to have_content("Viewing Party")
      end
    end
    it "has a button to create a new user" do
      within("#new-user") do
        expect(page).to have_button("Create New User")
        click_button("Create New User")
      end

      expect(current_path).to eq("/register")
    end
    it "has a list of existing users which links to the user dashboard" do
      
      @users.each do |user|
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        visit root_path
        within("#users") do
          expect(page).to have_link(user.email.to_s)
          click_link(user.email.to_s)
          expect(current_path).to eq("/users/#{user.id}")
          visit root_path
        end
      end
    end
    it "has a link to go back to the landing page" do
      within("#home") do
        expect(page).to have_link("Home")
        click_link "Home"
      end
      expect(current_path).to eq(root_path)
    end
  end
  describe 'login' do
    it 'has a link to log in' do
      visit root_path

      within("#log_in") do
        expect(page).to have_link("Log In")
        click_link "Log In"
      end

      expect(current_path).to eq(new_session_path)
    end
  end
  describe 'as a logged in user' do
    it 'no longer has a link to log in or create account, but has link to log out' do
      user = User.create!(name: "Katie", email: "email_address@gmail.com", password: "test123", password_confirmation: "test123")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit root_path
      expect(page).to have_no_content("Log In")
      expect(page).to have_no_content("Create New User")
      expect(page).to have_content("Log Out")
    end
    it 'when I log out, I return to landing page and the login link is back' do
      user = User.create!(name: "Katie", email: "email_address@gmail.com", password: "test123", password_confirmation: "test123")
      visit new_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_button "Log In"
      
      visit root_path
      click_button("Log Out")
      expect(current_path).to eq(root_path)
      expect(page).to have_content("Log In")
      expect(page).to have_content("Create New User")
    end
  end
  describe 'as a logged out user/visitor' do
    it 'does not show me the list of existing users' do
      test_data
      visit root_path
      expect(page).to have_no_content(@user_1.email)
      expect(page).to have_no_content(@user_2.email)
      expect(page).to have_no_content(@user_3.email)
    end
  end
end
