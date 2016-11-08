Rails.application.routes.draw do
  root to: 'sessions#new'
  
  resources :users
  get 'change_role', to: 'users#change_role'
  post 'change_role', to: 'users#update'
  
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
