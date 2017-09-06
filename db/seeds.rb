# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_arr = { sudo: ['sudo', 'sudo@lb.my', 123456, 123456],
             normal: ['normal', 'normal@lb.my', 123456, 123456]
            }
user_arr.each do |key, value|
  User.create!( name: value[0],
                email: value[1],
                password: value[2],
                password_confirmation: value[3])
end

for i in 1..100 do
  Contact.create!(name: "Person " + i.to_s, user_id: 1)
end

for i in 1..100 do
  Account.create!(account_name: "Acc " + i.to_s, user_id: 1)
end

for i in 1..100 do
  Opportunity.create!(name: "Op " + i.to_s, user_id: 1, account_id: 1)
end

for i in 1..8 do
  Stage.create!(name: "Stage " + i.to_s, opportunity_id: 1)
end

for i in 1..10 do
  Note.create!(title: "Sample note " + i.to_s,
  description: "Sample description " + i.to_s,
  info_id: 1, info_type: "Opportunity", user_id: 1)
end
