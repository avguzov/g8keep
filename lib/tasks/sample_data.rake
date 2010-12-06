require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_relationships
  end
end

def make_users
  admin = User.create!(:first_name => "Example",
					   :last_name => "User",
                       :email => "example@railstutorial.org",
                       :password => "foobar",
                       :password_confirmation => "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    first_name  = Faker::Name.name
	last_name = Faker::Name.last_name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:first_name => first_name,
				 :last_name => last_name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_relationships
  users = User.all
  user  = users.first
  accessing = users[1..50]
  accessors = users[3..40]
  accessing.each { |accessed| user.access!(accessed) }
  accessors.each { |accessors| accessor.access!(user) }
end