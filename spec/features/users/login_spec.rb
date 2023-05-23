# require 'rails_helper'

# RSpec.describe 'login page' do
#   describe 'as a registered user, when I visit the log in page' do
#     it 'I can input valid credentials and be taken to my dashboard' do
#       test_data
#       visit new_session_path

#       fill_in "Email", with: @user_1.email
#       fill_in "Password", with: @user_1.password

#       click_button "Log In"

#       expect(current_path).to eq("/users/#{@user_1.id}")
#     end
#   end
#   it 'flashes an error if my credentials are not correct' do
#     test_data
#     visit new_session_path

#     fill_in "Email", with: @user_1.email
#     fill_in "Password", with: 'incorrect password'

#     click_button "Log In"

#     expect(current_path).to eq(new_session_path)
#     expect(page).to have_content("Incorrect credentials.")
#   end
# end