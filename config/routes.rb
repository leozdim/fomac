Rails.application.routes.draw do
  resources :projects
  match 'projects/:id/add_people', to: 'projects#add_people', as: :add_project_people , via: :all
  get 'projects/:id/anexos', to: 'projects#anexos', as: :add_anexo_people
  match 'projects/:id/documents_people', to: 'projects#add_documents_people', as: :add_documents_people, via: :all
  resources :art_forms
  resources :categories
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    :registrations => "users/registrations",
    :confirmations => "users/confirmations",
    :passwords => "users/passwords"
  }
  resources :users
  resources :people
  root to: "projects#new"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
