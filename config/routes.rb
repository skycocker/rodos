Rodos::Application.routes.draw do
  root to: 'StaticPages#index'
  
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  match "/users" => 'users#index'
  match "/users/current" => 'users#current'
  
  resources :relationships
  resources :todos
  resources :groups
end
