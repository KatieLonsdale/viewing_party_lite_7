## Creates User class for user of the app
class User < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :email, email: true
  validates_presence_of :password_digest

  has_secure_password

  has_many :user_parties
  has_many :parties, through: :user_parties

  def no_parties?
    parties.empty?
  end

  def host_vps
    parties.joins(:user_parties).where("user_parties.is_host=true").distinct
  end

  def guest_vps
    parties.joins(:user_parties).where("user_parties.is_host=false").distinct
  end
end
