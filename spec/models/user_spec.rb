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
  end

  describe "instance methods" do
    before do
      test_data
    end

    it "#no_parties?" do
      expect(@user_1.no_parties?).to eq(true)
      expect(@user_2.no_parties?).to eq(false)
    end
  end
end
