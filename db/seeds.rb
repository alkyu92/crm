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

priority_arr = ['Normal', 'High']
priority_arr.each do |name|
  Priority.create!(name: name)
end

status_arr = ['Open', 'Closed']
status_arr.each do |name|
  Status.create!(name: name)
end

account_arr = ['a', 'b', 'c']
account_arr.each do |name|
  Account.create!(name: name)
end

opportunity_arr = ['opportunity one', 'opportunity two', 'opportunity three']
opportunity_arr.each do |op|
  Opportunity.create!(name: op, user_id: 1)
end

ops = Opportunity.all
ops.each do |op|
  for i in 1..10 do
    op.stages.create!(name: "Stage" + i.to_s)
  end
end
