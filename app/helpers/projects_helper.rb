module ProjectsHelper

  def get_status(field)
     test = Revision.where(user_id: @project.user.id, project_id: @project.id, field: field).order(:created_at).first
     test.blank? ? "Pendiente" : test.status
  end

  def get_observation_id(field)
    test = Revision.where(user_id: @project.user.id, project_id: @project.id, field: field).order(:created_at).first
    test.blank? ? "" : test.id
  end

  def get_observation(field)
    test = Revision.where(user_id: @project.user.id, project_id: @project.id, field: field).order(:created_at).first
    test.blank? ? " " : test.observations
  end


  def check_revisions models
    @invalid_fields=@project.invalid_revisions.where(:model=>models).pluck(:field,:observations)
    flash[:notice]='Algunos documentos son invalidos '  unless @invalid_fields.empty?
  end


  def redirect_control 
    if @project.finish? and @project.invalid_revisions.empty? 
      redirect_to project_finish_path(@project), notice: 'La evidencia del proyecto se guardo con èxito'   
    else
      yield
    end
  end

end
