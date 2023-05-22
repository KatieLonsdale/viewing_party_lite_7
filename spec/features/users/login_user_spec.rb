require 'rails_helper'

RSpec.describe "login user" do
  it "has email and password fields" do
    visit login_path
    expect(page).to have_field("email")
    expect(page).to have_field("password")
  end

  it "logs in user" do
    user = User.create!(name: "User", email: "email@email.com", password: "password123", password_confirmation: "password123")
    visit login_path
    
    fill_in :email, with: "#{user.email}"
    fill_in :password, with: "#{user.password}"
    click_on "Log In"

    expect(current_path).to eq("/users/#{user.id}")
    expect(page).to have_content("Session Started")
  end

  it "bad password" do
    user = User.create!(name: "User", email: "email@email.com", password: "password123", password_confirmation: "password123")
    visit login_path
    
    fill_in :email, with: "#{user.email}"
    fill_in :password, with: "Beepbopbaloobop"
    click_on "Log In"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Incorrect Password.")
  end

  it "wrong email" do
    user = User.create!(name: "User", email: "email@email.com", password: "password123", password_confirmation: "password123")
    visit login_path
    
    fill_in :email, with: "email@wrongemail.com"
    fill_in :password, with: "Beepbopbaloobop"
    click_on "Log In"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("An account with this email does not exist.")
  end

  it "case insensitive email" do
    visit root_path
    click_button("Create New User")

    fill_in("Name:", with: "Barbara")
    fill_in("Email", with: "BarBaRasEmAiL@Email.com")
    fill_in("Password", with: "babaras_password")
    fill_in("PasswordConfirmation", with: "babaras_password")
    click_button("Create User")
    visit root_path
    
    click_link("Log In")

    fill_in :email, with: "BaRBARasEmaIL@EmaIL.COM"
    fill_in :password, with: "babaras_password"
    click_on "Log In"

    expect(current_path).to eq("/users/#{User.last.id}")
    expect(page).to have_content("Session Started")
  end
end