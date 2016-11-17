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
end
