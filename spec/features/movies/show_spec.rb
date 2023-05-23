require 'rails_helper'

RSpec.describe "Movie Detail page" do
  describe "As a user, when I visit a movie's show page" do
    before(:each) do
      test_data
      test_movie_details
      @movie = Movie.new(@data)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end
    it "has a button to create a viewing party", :vcr do
      visit user_movie_path(@user_1.id, @movie.id)

      within("#create-vp") do
        expect(page).to have_button("Create Viewing Party for #{@movie.title}")
        click_button "Create Viewing Party for #{@movie.title}"
      end

      expect(current_path).to eq(new_user_movie_party_path(@user_1.id, @movie.id))
    end

    it "has a button to return to the discover page", :vcr do
      visit user_movie_path(@user_1.id, @movie.id)

      within("#return-to-discover") do
        expect(page).to have_button("Discover Page")
        click_button "Discover Page"
      end

      expect(current_path).to eq("/users/#{@user_1.id}/discover")
    end

    it "has the movie's information", :vcr do
      visit user_movie_path(@user_1.id, @movie.id)

      within("#movie-info") do
        expect(page).to have_content(@movie.title)
        expect(page).to have_content(@movie.vote_average)
        expect(page).to have_content(@movie.format_runtime)
        @movie.genres.each do |genre|
          expect(page).to have_content(genre)
        end
        expect(page).to have_content(@movie.overview)
      end
    end

    it "lists the first 10 cast members", :vcr do
      cast = MovieFacade.new.cast_members(@movie.id)
      visit user_movie_path(@user_1.id, @movie.id)

      within("#cast-members") do
        cast.each do |member|
          expect(page).to have_content(member.character)
          expect(page).to have_content(member.actor)
        end
      end
    end

    it "has a count of reviews and each review's author and info", :vcr do
      reviews = MovieFacade.new.all_reviews(@movie.id)
      visit user_movie_path(@user_1.id, @movie.id)

      within("#reviews") do
        expect(page).to have_content("#{reviews.count} Reviews")
        reviews.each do |review|
          expect(page).to have_content(review.author)
          expect(page).to have_content("Pretty awesome movie. It shows what one crazy person can convince other crazy people to do. Everyone needs something to believe in. I recommend Jesus Christ, but they want Tyler Durden.")
        end
      end
    end
  end
  describe 'as a logged out user/visitor' do
    it 'does not allow me to create a viewing party', :vcr do
      test_data
      test_movie_details
      @movie = Movie.new(@data)
      
      visit user_movie_path(@user_1.id, @movie.id)
      click_button "Create Viewing Party for #{@movie.title}"
      expect(current_path).to eq(user_movie_path(@user_1.id, @movie.id))
      expect(page).to have_content("You must be logged in to access your dashboard")
    end
  end
end
