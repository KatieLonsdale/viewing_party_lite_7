require 'rails_helper'

RSpec.describe "New Viewing party page" do
  describe "display" do
    before(:each) do
      test_data
      test_movie_details
      @movie_1 = Movie.new(@data)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it "has a form with all necessary fields", :vcr do
      visit new_user_movie_party_path(@user_1, @movie_1.id)

      expect(page).to have_content("Viewing Party Details")
      expect(page).to have_content(@movie_1.title)
      expect(page).to have_field("duration", with: 139)
      expect(page).to have_field("[day(1i)]")
      expect(page).to have_field("[day(2i)]")
      expect(page).to have_field("[day(3i)]")
      expect(page).to have_field("[time(4i)]")
      expect(page).to have_field("[time(5i)]")
      expect(page).to have_field(@user_1.id.to_s, type: 'checkbox')
      expect(page).to have_field(@user_2.id.to_s, type: 'checkbox')
      expect(page).to have_field(@user_3.id.to_s, type: 'checkbox')
      expect(page).to have_field(@user_4.id.to_s, type: 'checkbox')
      expect(page).to have_field(@user_5.id.to_s, type: 'checkbox')
      expect(page).to have_button("Create Party")
    end
  end

  describe "function" do
    before do
      test_data
      test_movie_details
      @movie_1 = Movie.new(@data)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it "creates viewing party", :vcr do
      sign_in_as(@user_1)
      @party_1 = Party.create!(duration: 200, date: "05/09/2023", time: "12:00", movie_id: 550)
      @party_1.user_parties.create!(user_id: @user_2.id)
      visit new_user_movie_party_path(@user_1, @movie_1.id)

      expect(@user_1.parties.count).to eq(0)
      expect(@user_2.parties.count).to eq(1)
      expect(@user_4.parties.count).to eq(0)

      fill_in("duration", with: 140)
      select "2023", from: "[day(1i)]"
      select "May", from: "[day(2i)]"
      select "25", from: "[day(3i)]"
      select "20", from: "[time(4i)]"
      select "30", from: "[time(5i)]"
      check(@user_2.id)
      check(@user_4.id)
      click_button("Create Party")
      expect(current_path).to eq('/dashboard')

      expect(@user_1.parties.count).to eq(1)
      expect(@user_2.parties.count).to eq(2)
      expect(@user_4.parties.count).to eq(1)
    end

    it "displays an error message if movie duration is longer than party duration", :vcr do
      visit new_user_movie_party_path(@user_1, @movie_1.id)

      fill_in("duration", with: 30)
      select "2023", from: "[day(1i)]"
      select "May", from: "[day(2i)]"
      select "25", from: "[day(3i)]"
      select "20", from: "[time(4i)]"
      select "30", from: "[time(5i)]"
      check(@user_2.id)
      check(@user_4.id)
      click_button("Create Party")

      expect(current_path).to eq(new_user_movie_party_path(@user_1, @movie_1.id))
      expect(page).to have_content("All fields must be filled out and party length must be greater than movie length")
    end

    it "displays an error message if fields are blank", :vcr do
      visit new_user_movie_party_path(@user_1, @movie_1.id)

      fill_in("duration", with: 30)
      select "2023", from: "[day(1i)]"
      select "May", from: "[day(2i)]"
      select "25", from: "[day(3i)]"
      select "20", from: "[time(4i)]"
      select "30", from: "[time(5i)]"
      check(@user_2.id)
      check(@user_4.id)
      click_button("Create Party")

      expect(current_path).to eq(new_user_movie_party_path(@user_1, @movie_1.id))
      expect(page).to have_content("All fields must be filled out and party length must be greater than movie length")
    end
  end
end
