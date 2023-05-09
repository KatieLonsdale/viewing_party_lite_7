class Party < ApplicationRecord
  validates_numericality_of :duration
  validates_presence_of :date
  validates_presence_of :time
  validates_presence_of :host

  has_many :user_parties
  has_many :users, through: :user_parties
end