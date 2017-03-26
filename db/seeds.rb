# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name:  "Example User",
             email: "example@quizzup.com",
             password:              "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now
             )

User.create!( name: "Admin User",
              email: "admin@quizzup.com", 
              password: 'password',
              password_confirmation: 'password',
              admin: true,
              activated: true,
              activated_at: Time.zone.now
             )


10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@quizzup.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now
               )
end 

=begin
30.times do |n|
  name = ''
  about = ''
  image = 'https://pbs.twimg.com/profile_images/453956388851445761/8BKnRUXg.png'
  case n%5
  when  0
    name = Faker::Ancient.hero
    about = Faker::Lorem.paragraph
    Topic.create!(name: name, about: about, image: image)
  when  1
    name = Faker::LordOfTheRings.character
    about = Faker::Lorem.paragraph
    Topic.create!(name: name, about: about, image: image)
  when  2
    name = Faker::GameOfThrones.character
    about = Faker::Lorem.paragraph
    Topic.create!(name: name, about: about, image: image)
  when  3
    name = Faker::Book.title
    about = Faker::Lorem.paragraph
    Topic.create!(name: name, about: about, image: image)
  when  4
    name = Faker::Pokemon.name
    about = Faker::Lorem.paragraph
    Topic.create!(name: name, about: about, image: image)
  end
end

=end

=begin
t = Topic.new(name: "Physics", about: "The branch of science concerned with the nature and properties of matter and energy. The subject matter of physics includes mechanics, heat, light and other radiation, sound, electricity, magnetism, and the structure of atoms.", image: "https://lh3.googleusercontent.com/tqTckUEHvs5_DEbUH9V0KoyPrGnuoorCGqg_f4j3JQlCjxoYQ11Qm18bXz7h6622llc=w300")
t.save
t = Topic.new(name: "Mathematics", about: "The abstract science of number, quantity, and space, either as abstract concepts ( pure mathematics ), or as applied to other disciplines such as physics and engineering ( applied mathematics ).", image: "http://s3.amazonaws.com/spoonflower/public/design_thumbnails/0027/0803/rrsandy_maths_sharon_turner_scrummy_things_shop_preview.png")
t.save
t = Topic.new(name: "Chemistry", about: "The branch of science concerned with the substances of which matter is composed, the investigation of their properties and reactions, and the use of such reactions to form new substances.", image: "https://cdn.sstatic.net/Sites/chemistry/img/apple-touch-icon@2.png?v=469e81391644")
t.save
t = Topic.new(name: "Algebra", about: 'The part of mathematics in which letters and other general symbols are used to represent numbers and quantities in formulae and equations.', image: 'https://johnhdavisdotcom.files.wordpress.com/2014/08/hw-algebra.jpeg')
t.save


t = Topic.find_by(name: 'Mathematics')
ta = Topic.find_by(name: 'Algebra')
t.subtopics << ta


q = Question.new(question: 'What is conjugate of z, if z = 3+4i ?', question_type: 2, answer: '3-4i')
t = Topic.find_by(name: 'Algebra')
u = User.first
q.topic = t
t.questions << q
u.submitted_questions << q
q.creator = u
q.save


q = Question.new(question: 'What is |z|, if z = 3+4i ?', question_type: 1, answer: '5')
t = Topic.find_by(name: 'Algebra')
u = User.first
q.topic = t
u.submitted_questions << q
q.save



c = Choice.new(choice: '4')
q.choices << c

c = Choice.new(choice: '5')
q.choices << c

c = Choice.new(choice: '6')
q.choices << c

c = Choice.new(choice: '7')
q.choices << c

=end


