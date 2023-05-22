# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'simplecov'
SimpleCov.start do
  add_filter "spec/testable.rb"
end

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data('<MOVIEDB_AUTHORIZATION_TOKEN>') { ENV["MOVIEDB_AUTHORIZATION_TOKEN"] }
  config.default_cassette_options = { re_record_interval: 7.days }
  config.configure_rspec_metadata!
end

def test_data
  UserParty.destroy_all
  User.destroy_all
  Party.destroy_all

  @user_1 = User.create!(name: "User 1", email: "email1@email.com", password: "pass123")
  @user_2 = User.create!(name: "User 2", email: "email2@email.com", password: "pass123")
  @user_3 = User.create!(name: "User 3", email: "email3@email.com", password: "pass123")
  @user_4 = User.create!(name: "User 4", email: "email4@email.com", password: "pass123")
  @user_5 = User.create!(name: "User 5", email: "email5@email.com", password: "pass123")
end

def test_movie
  @data = {
    "adult": false,
    "backdrop_path": "/hZkgoQYus5vegHoetLkCJzb17zJ.jpg",
    "genre_ids": [
      18,
      53,
      35
    ],
    "id": 550,
    "original_language": "en",
    "original_title": "Fight Club",
    "overview": "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
    "popularity": 56.3,
    "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
    "release_date": "1999-10-15",
    "title": "Fight Club",
    "video": false,
    "vote_average": 8.4,
    "vote_count": 26_357
  }
end

def test_movie_details
  @data = {
    "adult": false,
    "backdrop_path": "/hZkgoQYus5vegHoetLkCJzb17zJ.jpg",
    "belongs_to_collection": nil,
    "budget": 63_000_000,
    "genres": [
      {
        "id": 18,
        "name": "Drama"
      },
      {
        "id": 53,
        "name": "Thriller"
      },
      {
        "id": 35,
        "name": "Comedy"
      }
    ],
    "homepage": "http://www.foxmovies.com/movies/fight-club",
    "id": 550,
    "imdb_id": "tt0137523",
    "original_language": "en",
    "original_title": "Fight Club",
    "overview": "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
    "popularity": 58.696,
    "poster_path": "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
    "production_companies": [
      {
        "id": 508,
        "logo_path": "/7cxRWzi4LsVm4Utfpr1hfARNurT.png",
        "name": "Regency Enterprises",
        "origin_country": "US"
      },
      {
        "id": 711,
        "logo_path": "/tEiIH5QesdheJmDAqQwvtN60727.png",
        "name": "Fox 2000 Pictures",
        "origin_country": "US"
      },
      {
        "id": 20_555,
        "logo_path": "/hD8yEGUBlHOcfHYbujp71vD8gZp.png",
        "name": "Taurus Film",
        "origin_country": "DE"
      },
      {
        "id": 54_051,
        "logo_path": nil,
        "name": "Atman Entertainment",
        "origin_country": ""
      },
      {
        "id": 54_052,
        "logo_path": nil,
        "name": "Knickerbocker Films",
        "origin_country": "US"
      },
      {
        "id": 4700,
        "logo_path": "/A32wmjrs9Psf4zw0uaixF0GXfxq.png",
        "name": "The Linson Company",
        "origin_country": "US"
      },
      {
        "id": 25,
        "logo_path": "/qZCc1lty5FzX30aOCVRBLzaVmcp.png",
        "name": "20th Century Fox",
        "origin_country": "US"
      }
    ],
    "production_countries": [
      {
        "iso_3166_1": "US",
        "name": "United States of America"
      }
    ],
    "release_date": "1999-10-15",
    "revenue": 100_853_753,
    "runtime": 139,
    "spoken_languages": [
      {
        "english_name": "English",
        "iso_639_1": "en",
        "name": "English"
      }
    ],
    "status": "Released",
    "tagline": "Mischief. Mayhem. Soap.",
    "title": "Fight Club",
    "video": false,
    "vote_average": 8.4,
    "vote_count": 26_372
  }
end

def test_review
  @data = {
    "author": "Goddard",
    "author_details": {
      "name": "",
      "username": "Goddard",
      "avatar_path": "/https://secure.gravatar.com/avatar/f248ec34f953bc62cafcbdd81fddd6b6.jpg",
      "rating": nil
    },
    "content": "Pretty awesome movie. It shows what one crazy person can convince other crazy people to do. Everyone needs something to believe in. I recommend Jesus Christ, but they want Tyler Durden.",
    "created_at": "2018-06-09T17:51:53.359Z",
    "id": "5b1c13b9c3a36848f2026384",
    "updated_at": "2021-06-23T15:58:09.421Z",
    "url": "https://www.themoviedb.org/review/5b1c13b9c3a36848f2026384"
  }
end

def test_cast_member
  @data = {
    "adult": false,
    "gender": 2,
    "id": 819,
    "known_for_department": "Acting",
    "name": "Edward Norton",
    "original_name": "Edward Norton",
    "popularity": 32.008,
    "profile_path": "/8nytsqL59SFJTVYVrN72k6qkGgJ.jpg",
    "cast_id": 4,
    "character": "The Narrator",
    "credit_id": "52fe4250c3a36847f80149f3",
    "order": 0
  }
end
