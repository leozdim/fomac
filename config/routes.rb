Rails.application.routes.draw do
  resources :evaluations
  resources :project_assignments
  resources :revisions
  get 'revisions/observation'
  get 'revisions/validate' , to: 'revisions#validate'
  get 'static_pages/home'
  get 'static_pages/creator'
  get 'static_pages/project'
  get 'static_pages/evidence'
  post 'static_pages/savenew'

  resources :projects
  match 'projects/:id/add_people', to: 'projects#add_people', as: :add_project_people , via: :all
  get 'projects/:id/anexos', to: 'projects#anexos', as: :add_anexo_people
  match 'projects/:id/documents_people', to: 'projects#add_documents_people', as: :add_documents_people, via: :all
  match 'projects/:id/information', to: 'projects#information', as: :project_information, via: :all
  match 'projects/:id/retribution', to: 'projects#retribution', as: :project_retribution, via: :all
  match 'projects/:id/evidence', to: 'projects#evidence', as: :project_evidence, via: :all
  match 'projects/:id/finish', to: 'projects#finish', as: :project_finish, via: :all
  match '/uploads/:class/:as/:id/:basename.:extension', to: 'projects#download', via: :all, as: :download_doc, :constraints => { :extension => /[^\/]+/ }
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
