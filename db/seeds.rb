# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_arr = { sudo: ['Ali', 'ali@lb.my', 'Employee', 'MIS', 123456, 123456],
             normal: ['normal', 'normal@lb.my', 'Employee', 'Marketing', 123456, 123456]
            }
user_arr.each do |key, value|
  User.create!( name: value[0],
                email: value[1],
                title: value[2],
                department: value[3],
                password: value[4],
                password_confirmation: value[5])
end

department = [
  "Marketing",
  "Purchasing",
  "Machining",
  "Logistics",
  "Maintenance",
  "Planner",
  "Quality Control",
  "Finance",
  "Information Management"
]
for i in 1..20 do
  Contact.create!(
  name: "Person #{i}",
  title: "Employee",
  department: department.sample,
  email: "Person#{i}@lb.my",
  phone: "123-456-789",
  fax: "098-765-432",

  mailing_street: "No. 123, Jalan 123,",
  mailing_city: "Johor Bahru",
  mailing_state: "Johor",
  mailing_postal_code: "80000",
  mailing_country: "MY",

  user_id: 1)
end

Account.create!(
account_name: "Local Basic Sdn. Bhd.",
account_type: "Partner",
website: "www.localbasic.com.my",
email: "test@example.com",
description: "Company description",
phone: "123-456-890",
fax: "098-765-432",
industry: "Aluminium",
number_of_employee: 200,

billing_street: "No. 123, Jalan 123,",
billing_city: "Johor Bahru",
billing_state: "Johor",
billing_postal_code: "80000",
billing_country: "MY",

shipping_street: "No. 123, Jalan 123,",
shipping_city: "Johor Bahru",
shipping_state: "Johor",
shipping_postal_code: "80000",
shipping_country: "MY",
user_id: 1)

Account.create!(
account_name: "Local Casting Sdn. Bhd.",
account_type: "Partner",
website: "www.localbasic.com.my",
email: "test@example.com",
description: "Company description",
phone: "123-456-890",
fax: "098-765-432",
industry: "Aluminium",
number_of_employee: 200,

billing_street: "No. 123, Jalan 123,",
billing_city: "Johor Bahru",
billing_state: "Johor",
billing_postal_code: "80000",
billing_country: "MY",

shipping_street: "No. 123, Jalan 123,",
shipping_city: "Johor Bahru",
shipping_state: "Johor",
shipping_postal_code: "80000",
shipping_country: "MY",
user_id: 1)

Account.create!(
account_name: "Anchor",
account_type: "Sub-contractor",
website: "anchor.website",
email: "test@example.com",
description: "Company description",
phone: "123-456-890",
fax: "098-765-432",
industry: "Painting",
number_of_employee: 200,

billing_street: "No. 123, Jalan 123,",
billing_city: "Johor Bahru",
billing_state: "Johor",
billing_postal_code: "80000",
billing_country: "MY",

shipping_street: "No. 123, Jalan 123,",
shipping_city: "Johor Bahru",
shipping_state: "Johor",
shipping_postal_code: "80000",
shipping_country: "MY",
user_id: 1)

industry = [
  "Aluminium Manufacturing",
  "Consumer Electronics",
  "Electrical Power Grid",
  "Industrial Chemical",
  "Oil and Gas",
  "Automotive",
  "Sport Utilities"
]
for i in 1..20 do
  Account.create!(
  account_name: "Test Account Name #{i}",
  account_type: "Customer",
  website: "www.test#{i}-website.com",
  email: "test#{i}@example.com",
  description: "Test#{i} account description",
  phone: "123-456-890",
  fax: "098-765-432",
  industry: industry.sample,
  number_of_employee: 200,

  billing_street: "No. 123, Jalan 123,",
  billing_city: "Johor Bahru",
  billing_state: "Johor",
  billing_postal_code: "80000",
  billing_country: "MY",

  shipping_street: "No. 123, Jalan 123,",
  shipping_city: "Johor Bahru",
  shipping_state: "Johor",
  shipping_postal_code: "80000",
  shipping_country: "MY",
  user_id: 1)
end

Opportunity.create!(
name: "Case 22",
business_type: "Case",
probability: "",
amount: 1000.12,
description: "Case 22 description",
loss_reason: "",
close_date: "",
status: "In Progress",
user_id: 1,
account_id: 1)

Opportunity.create!(
name: "Shimano Product One Processes",
business_type: "Opportunity",
probability: "",
amount: 123456.78,
description: "Description",
loss_reason: "",
close_date: "",
status: "Open",
user_id: 1,
account_id: 1)

process = ['Die and Tooling','Casting','Machining','Secondary Process', 'Finishing', 'Inspection']
process.each do |prc|
  Stage.create!(
  name: prc,
  status: "Waiting",
  current_status: false,
  opportunity_id: 2,
  user_id: 1,
  updated_by_id: 1)
end

for j in 1..10 do
  for i in 1..5 do
    Opportunity.create!(
    name: "Test Opportunity Open Status #{i}",
    business_type: "Opportunity",
    probability: "75%",
    amount: 12345.35,
    description: "Test#{i} opportunity description",
    loss_reason: "",
    close_date: "",
    status: "Open",
    user_id: 1,
    account_id: j)
  end

  for i in 1..5 do
    Opportunity.create!(
    name: "Test Opportunity Closed-Won Status #{i}",
    business_type: "Opportunity",
    probability: "75%",
    amount: 12345.35,
    description: "Test#{i} opportunity description",
    loss_reason: "",
    close_date: Time.now,
    status: "Closed-Won",
    user_id: 1,
    account_id: j)
  end

  for i in 1..5 do
    Opportunity.create!(
    name: "Test Opportunity Closed-Loss Status #{i}",
    business_type: "Opportunity",
    probability: "75%",
    amount: 12345.35,
    description: "Test#{i} opportunity description",
    loss_reason: "",
    close_date: Time.now,
    status: "Closed-Loss",
    user_id: 1,
    account_id: j)
  end

  for i in 1..5 do
    Opportunity.create!(
    name: "Test Opportunity Approved Status #{i}",
    business_type: "Opportunity",
    probability: "75%",
    amount: 12345.35,
    description: "Test#{i} opportunity description",
    loss_reason: "",
    close_date: "",
    status: "Approved",
    user_id: 1,
    account_id: j)
  end
end

for j in 1..10 do
  for i in 1..10 do
    Opportunity.create!(
    name: "Test Case #{i}",
    business_type: "Case",
    probability: "",
    amount: 23456.56,
    description: "Test#{i} case description",
    loss_reason: "",
    close_date: "",
    status: "In Progress",
    user_id: 1,
    account_id: j)
  end
end

for i in 1..15 do
  Stage.create!(
  name: "Test Stage #{i}",
  status: "Waiting",
  current_status: false,
  opportunity_id: 1,
  user_id: 1,
  updated_by_id: 1)
end

for i in 1..20 do
  Note.create!(
  title: "Sample note #{i}",
  description: "Sample description #{i}",
  info_id: 1,
  info_type: "Opportunity",
  user_id: 1)
end

Task.create!(
description: "Urgent task",
due_date: 2.day.from_now,
polytask_id: 1,
polytask_type: "Opportunity",
user_id: 1)

for i in 1..20 do
  Task.create!(
  description: "Sample task #{i}",
  due_date: 1.week.from_now,
  polytask_id: 1,
  polytask_type: "Opportunity",
  user_id: 1)
end

for i in 1..20 do
  Call.create!(
  description: "Sample call log #{i}",
  call_datetime: 1.week.from_now,
  duration: 5,
  polycall_id: 1,
  polycall_type: "Opportunity",
  user_id: 1)
end

Event.create!(
description: "Urgent event",
event_date: 1.day.from_now,
polyevent_id: 1,
polyevent_type: "Opportunity",
user_id: 1)

for i in 1..20 do
  Event.create!(
  description: "Sample event #{i}",
  event_date: 1.week.from_now,
  polyevent_id: 1,
  polyevent_type: "Opportunity",
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
