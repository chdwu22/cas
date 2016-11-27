Rails.application.routes.draw do
  resources :timeslots
  resources :courses
  resources :rooms
  resources :buildings
  root to: 'pages#rootpage'
  
  get 'admin_main', to: 'pages#admin_main'
  get 'assignment_table', to:'pages#assignment_table'
  
  resources :users
  get 'change_role', to: 'users#change_role'
  post 'change_role', to: 'users#update'
  get 'assignment_by_faculty', to:'users#assignment_by_faculty'
  
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'get_current_semester', to:'systemvariables#get_current_semester'
  get 'set_current_semester', to:'systemvariables#set_current_semester'
  
  get 'new_day', to:'systemvariables#new_day'
  get 'create_day', to:'systemvariables#create_day'
  get 'delete_day', to:'systemvariables#delete_day'
  get 'new_time', to:'systemvariables#new_time'
  get 'create_time', to:'systemvariables#create_time'
  get 'delete_time', to:'systemvariables#delete_time'
  get 'faculty_edit_permission', to:'systemvariables#faculty_edit_permission'
  get 'set_faculty_permission', to:'systemvariables#set_faculty_permission'
  get 'unacceptable_time_slot_limit', to:'systemvariables#unacceptable_time_slot_limit'
  get 'set_unacceptable_limit', to:'systemvariables#set_unacceptable_limit'
  get 'preferred_time_slot_limit', to:'systemvariables#preferred_slot_limit'
  get 'set_preferred_limit', to:'systemvariables#set_preferred_limit'
  
  get 'new_time_table', to:'timeslots#new_time_table'
  get 'time_table', to:'timeslots#show_time_table'
  get 'anm_table', to:'timeslots#anm_table'
  
  get 'set_preference', to:'timeslot_users#set_preference'
  
  get 'copy_courses', to:'courses#copy_courses'
  #get 'assign_room', to:'courses#assign_room'
  #get 'set_course_time', to:'courses#set_course_time'
end
