require 'rails_helper'

RSpec.describe "user registration page", type: :feature do
  describe "display" do
    it "has new user form" do
      visit '/register'

      expect(page).to have_content("Register a New User")

      expect(page).to have_field("Name:")
      expect(page).to have_field("Email")
      expect(page).to have_button("Create User")
    end
  end

  describe "function" do
    it "registers new user" do
      visit '/register'

      fill_in("Name:", with: "Barbara")
      fill_in("Email", with: "BarbarasEmail@Email.com")
      fill_in("Password", with: "password123")
      fill_in("Password Confirmation", with: "password123")
      click_button("Create User")

      expect(current_path).to eq("/users/#{User.last.id}")
      expect(page).to have_content("Barbara's Dashboard")
    end
  end

  describe "sad path" do
    it "email not unique" do
      visit '/register'

      fill_in("Name:", with: "Barbara")
      fill_in("Email", with: "BarbarasEmail@Email.com")
      click_button("Create User")

      visit '/register'

      fill_in("Name:", with: "John")
      fill_in("Email", with: "BarbarasEmail@Email.com")
      click_button("Create User")

      expect(current_path).to eq('/register')
      expect(page).to have_content("All fields must be filled out and email must be unique")
    end

    it "fields not filled out" do
      visit '/register'

      fill_in("Name:", with: "Barbara")
      click_button("Create User")

      expect(current_path).to eq('/register')
      expect(page).to have_content("All fields must be filled out and email must be unique")
    end

    it "not valid email" do
      visit '/register'

      fill_in("Name:", with: "John")
      fill_in("Email", with: "kjshdfkjshdf")
      click_button("Create User")

      expect(current_path).to eq('/register')
      expect(page).to have_content("All fields must be filled out and email must be unique")
    end

    it "passwords don't match" do
      visit '/register'

      fill_in("Password", with: "password123")
      fill_in("Password Confirmation", with: "differentpassword")
      click_button("Create User")

      expect(current_path).to eq('/register')
      expect(page).to have_content("Passwords must match")
      expect(User.all.count).to eq(0)
    end
  end

  describe 'login' do
    it 'has a link to log in' do
      visit '/register'

      expect(page).to have_link("Log In")
      click_link "Log In"

      expect(current_path).to eq('/login')
    end
  end
end
