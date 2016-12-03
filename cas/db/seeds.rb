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


User.create!({:first_name => 'Super', :last_name => 'Admin', :full_name=>'Admin, Super',:is_admin=>true, :email=>'admin@tamu.edu', :password=>"asdfa"})
Room.create!({:number => 'N/A', :capacity=>1000})

timeslots = [{:day=>"MWF", :from_time=>800, :to_time=>850},
            {:day=>"MWF", :from_time=>910, :to_time=>1000},
            {:day=>"MWF", :from_time=>1020, :to_time=>1110},
            {:day=>"MWF", :from_time=>1130, :to_time=>1220},
            {:day=>"MWF", :from_time=>1350, :to_time=>1440},
            {:day=>"MWF", :from_time=>1500, :to_time=>1550},
            {:day=>"MW", :from_time=>1610, :to_time=>1725},
            {:day=>"MW", :from_time=>1745, :to_time=>1900},
            {:day=>"TR", :from_time=>800, :to_time=>915},
            {:day=>"TR", :from_time=>935, :to_time=>1050},
            {:day=>"TR", :from_time=>1110, :to_time=>1225},
            {:day=>"TR", :from_time=>1245, :to_time=>1400},
            {:day=>"TR", :from_time=>1420, :to_time=>1535},
            {:day=>"TR", :from_time=>1555, :to_time=>1710},
            {:day=>"TR", :from_time=>1730, :to_time=>1845},
            {:day=>"TR", :from_time=>1920, :to_time=>2035},
            {:day=>"M", :from_time=>1745, :to_time=>2015},
            {:day=>"T", :from_time=>1730, :to_time=>2000},
            {:day=>"W", :from_time=>1745, :to_time=>2015},
            {:day=>"R", :from_time=>1730, :to_time=>2000} ]
    
timeslots.each do |ts|
  Timeslot.create!(ts)
end
