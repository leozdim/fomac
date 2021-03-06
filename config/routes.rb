Rails.application.routes.draw do
  resources :selected_projects
  resources :evaluations
  resources :project_assignments
  resources :revisions
  resources :reports, only: [:new, :create, :show, :edit, :update, :destroy]

  get 'revisions/observation'
  get 'revisions/validate' , to: 'revisions#validate'
  get 'static_pages/reports_by_project' , to: 'static_pages#reports_by_project',as: :static_pages_reports_by_project
  get 'static_pages/reports_by_project_id' , to: 'static_pages#reports_by_project_id',as: :stsatic_pages_reports_id_by_project

  get 'static_pages/home'
  get 'static_pages/creator'
  get 'static_pages/project'
  get 'static_pages/project_scores'
  get 'static_pages/privacy'
  get 'static_pages/evidence'
  post 'static_pages/savenew'
  get 'static_pages/save_selected', to: 'static_pages#save_selected',as: :static_pages_save_selected


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
