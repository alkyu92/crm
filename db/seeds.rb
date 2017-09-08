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
  Account.create!(
  account_name: "Test Account Name" + i.to_s,
  account_type: "Customer",
  website: "www.test-website.com",
  email: "test@example.com",
  description: "Test account description",
  phone: "123-456-890",
  fax: "098-765-432",
  industry: "Aluminium",
  number_of_employee: 200,

  billing_street: "No. 123, Jalan 123,",
  billing_city: "Johor Bahru",
  billing_state: "Johor",
  billing_postal_code: "80000",
  billing_country: "Malaysia",

  shipping_street: "No. 123, Jalan 123,",
  shipping_city: "Johor Bahru",
  shipping_state: "Johor",
  shipping_postal_code: "80000",
  shipping_country: "Malaysia",
  user_id: 1)
end

for i in 1..100 do
  Opportunity.create!(
  name: "Op " + i.to_s,
  business_type: "New business",
  probability: "75%",
  amount: "RM 1,000,000",
  description: "Test opportunity description",
  loss_reason: "",
  close_date: "",
  status: "Open",
  user_id: 1,
  account_id: 1)
end

for i in 1..15 do
  Stage.create!(
  name: "Stage " + i.to_s,
  status: "Waiting",
  current_status: false,
  opportunity_id: 1,
  user_id: 1,
  updated_by_id: 1)
end

for i in 1..10 do
  Note.create!(
  title: "Sample note " + i.to_s,
  description: "Sample description " + i.to_s,
  info_id: 1,
  info_type: "Opportunity",
  user_id: 1)
end

for i in 1..10 do
  Task.create!(
  description: "Sample task " + i.to_s,
  due_date: 1.week.from_now,
  opportunity_id: 1,
  user_id: 1)
end

for i in 1..10 do
  Call.create!(
  description: "Sample call log " + i.to_s,
  call_datetime: 1.week.from_now,
  duration: 5,
  opportunity_id: 1,
  user_id: 1)
end

for i in 1..10 do
  Event.create!(
  description: "Sample event " + i.to_s,
  event_date: 1.week.from_now,
  opportunity_id: 1,
  user_id: 1)
end

# testing timeline month display
@op = Opportunity.first
@op.timelines.create!(tactivity: "try",
                      nactivity: "timeline",
                      action: "created test",
                      user_id: 1,
                      activity_type: "Opportunity",
                      activity_id: 1)

@op.timelines.create!(tactivity: "try",
                      nactivity: "timeline",
                      action: "created test",
                      user_id: 1,
                      activity_type: "Opportunity",
                      activity_id: 1,
                      created_at: 1.month.ago,
                      updated_at: 1.month.ago)

@op.timelines.create!(tactivity: "try",
                      nactivity: "timeline",
                      action: "created test",
                      user_id: 1,
                      activity_type: "Opportunity",
                      activity_id: 1,
                      created_at: 2.month.ago,
                      updated_at: 2.month.ago)

# testing contact association
@contact = Contact.first
@op.relationships.create!(contact: @contact)
