module ProjectsHelper

  def get_status(field)
     test = Revision.where(user_id: @project.user.id, project_id: @project.id, field: field).order(:created_at).first
     test.blank? ? "Pendiente" : test.status
  end

  def get_observation(field)
    test = Revision.where(user_id: @project.user.id, project_id: @project.id, field: field).order(:created_at).first
    test.blank? ? " " : test.observations
  end
end
