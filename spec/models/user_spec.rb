require 'rails_helper'

RSpec.describe User do
  describe "relationships" do
    it { should have_many(:user_parties) }
    it { should have_many(:parties).through(:user_parties) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password_digest)}
    it { should have_secure_password}

    it 'should store passwords safely' do
      user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')
      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq('password123')
    end
  end

  describe "instance methods" do
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

    it "#no_parties?", :vcr do
      expect(@user_1.no_parties?).to eq(true)
      expect(@user_2.no_parties?).to eq(false)
    end

    it "host_vps", :vcr do
      expect(@user_1.host_vps).to eq([])
      expect(@user_3.host_vps).to eq([@party_2])
      expect(@user_4.host_vps).to eq([@party_1])
    end

    it "guest_vps", :vcr do
      expect(@user_1.guest_vps).to eq([])
      expect(@user_3.guest_vps).to eq([@party_1])
      expect(@user_4.guest_vps).to eq([@party_2])
    end
  end
end
