# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

variables = [{:name => 'unacceptable_time_slot_limit', :value => '6'},
    	       {:name => 'scheduling_year', :value => '2017'},
    	       {:name => 'scheduling_semester', :value => 'Fall'},
      	     {:name => 'enable_faculty_edit?', :value => 'yes'}
  	 ]

variables.each do |v|
  Systemvariable.create!(v)
end