require 'rails_helper'

RSpec.describe 'login page' do
  describe 'as a registered user, when I visit the log in page' do
    it 'I can input valid credentials and be taken to my dashboard' do
      test_data
      visit '/login'

      fill_in "Email", with: @user_1.email
      fill_in "Password", with: @user_1.password

      click_button "Log In"

      expect(current_path).to eq("/users/#{@user_1.id}")
    end
  end
end