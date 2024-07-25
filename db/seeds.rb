# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(name: 'Example User', email: 'example@railstutorial.org', password: 'foobar',
             password_confirmation: 'foobar', admin: true, activated: true, activated_at: Time.zone.now)
30.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(name:, email:, password:, password_confirmation: password)
end
users = User.order(:created_at).take(6)
30.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content:) }
end
users = User.all
user = users.first
following = users[2..20]
followers = users[3..15]
following.each do |followed|
  user.follow(followed)
end
followers.each do |follower|
  follower.follow(user)
end
