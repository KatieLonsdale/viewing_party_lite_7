# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

UserParty.destroy_all
User.destroy_all
Party.destroy_all

@user_1 = User.create!(name: "User 1", email: "email1@email.com", password: "test123", password_confirmation: "test123")
@user_2 = User.create!(name: "User 2", email: "email2@email.com", password: "test123", password_confirmation: "test123")
@user_3 = User.create!(name: "User 3", email: "email3@email.com", password: "test123", password_confirmation: "test123")
@user_4 = User.create!(name: "User 4", email: "email4@email.com", password: "test123", password_confirmation: "test123")
@user_5 = User.create!(name: "User 5", email: "email5@email.com", password: "test123", password_confirmation: "test123")

@party_1 = Party.create!(duration: 200, date: "Tue, 9 May 2023", time: "12:00", movie_id: 238)
@party_2 = Party.create!(duration: 180, date: "Mon, 16 Jan 2023", time: "18:00", movie_id: 550)

@party_1.user_parties.create!(user_id: @user_2.id)
@party_1.user_parties.create!(user_id: @user_3.id)
@party_1.user_parties.create!(user_id: @user_4.id, is_host: true)
@party_2.user_parties.create!(user_id: @user_3.id, is_host: true)
@party_2.user_parties.create!(user_id: @user_4.id)
@party_2.user_parties.create!(user_id: @user_5.id)
