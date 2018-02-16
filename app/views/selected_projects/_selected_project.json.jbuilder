json.extract! selected_project, :id, :project_id, :created_at, :updated_at
json.url selected_project_url(selected_project, format: :json)
