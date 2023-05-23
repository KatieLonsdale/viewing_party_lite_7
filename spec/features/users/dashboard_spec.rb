require 'rails_helper'

RSpec.describe "user dashboard page", type: :feature do
  describe "display" do
    before do
      test_data
      @party_1 = Party.create!(duration: 200, date: "Tue, 9 May 2023", time: "12:00", movie_id: 238)
      @party_2 = Party.create!(duration: 180, date: "Mon, 16 Jan 2023", time: "18:00", movie_id: 550)

      @party_1.user_parties.create!(user_id: @user_2.id)
      @party_1.user_parties.create!(user_id: @user_3.id)
      @party_1.user_parties.create!(user_id: @user_4.id, is_host: true)
      @party_2.user_parties.create!(user_id: @user_3.id, is_host: true)
      @party_2.user_parties.create!(user_id: @user_4.id)
      @party_2.user_parties.create!(user_id: @user_5.id)
    end

    it "has user's name, a discover button, and a party viewing section", :vcr do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
      visit "/users/#{@user_1.id}"

      expect(page).to have_content("User 1's Dashboard")
      expect(page).to have_button("Discover Movies")
      within("#parties") do
        expect(page).to have_content("This user has no parties yet")
      end

      click_button("Discover Movies")
      expect(current_path).to eq("/users/#{@user_1.id}/discover")
    end

    it "lists viewing parties that I am invited to with VP info", :vcr do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_3)
      visit "/users/#{@user_3.id}"

      within("#hosted-vps") do
        expect(page).to have_content("Fight Club")
        expect(page).to have_content(@party_2.format_date)
        expect(page).to have_content(@party_2.format_time)
        expect(page).to have_content("Hosting")
        expect(page).to have_content("#{@user_4.name}")
        expect(page).to have_content("#{@user_5.name}")
      end

      within("#guest-vps") do
        expect(page).to have_content(@party_1.format_date)
        expect(page).to have_content(@party_1.format_time)
        expect(page).to have_content("Invited")
        expect(page).to have_content("Hosted by: #{@user_4.name}")
        expect(page).to have_content("#{@user_2.name}")
        expect(page).to have_content("#{@user_3.name}")
      end
    end

    it "has movie titles linked to their show page", :vcr do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_3)
      visit "/users/#{@user_3.id}"

      click_link "Fight Club"
      expect(current_path).to eq(user_movie_path(@user_3.id, 550))
    end
  end
end
