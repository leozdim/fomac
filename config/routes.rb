Rails.application.routes.draw do
  resources :art_forms
  resources :categories
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    :registrations => "users/registrations"
  }
  resources :users
  resources :people
  root to: "users#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
