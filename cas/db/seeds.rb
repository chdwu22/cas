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
      	     {:name => 'enable_faculty_edit?', :value => 'yes'},
      	     {:name => 'preferred_time_slot_limit', :value => '3'}
  	 ]

variables.each do |v|
  Systemvariable.create!(v)
end


User.create!({:first_name => 'super', :last_name => 'admin', :full_name=>'super admin',:is_admin=>true, :email=>'admin@tamu.edu', :password=>"asdf"})
Building.create!({:name => 'TBD'})
Room.create!({:number => '1', :capacity=>1000, :building_id=>1})