Rails.application.routes.draw do
  resources :timeslots
  resources :courses
  resources :rooms
  resources :buildings
  root to: 'pages#root'
  
  get 'admin_main', to: 'pages#admin_main'
  
  resources :users
  get 'change_role', to: 'users#change_role'
  post 'change_role', to: 'users#update'
  
  
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
  
  get 'new_time_table', to:'timeslots#new_time_table'
  get 'time_table', to:'timeslots#show_time_table'
end
