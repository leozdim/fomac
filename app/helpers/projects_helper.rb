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
    @invalid_fields=@project.invalid_revisions.where(:model=>models).pluck(:field,:observations,:model)
    # salvador put some trash in the field name
    flash[:notice]='Algunos documentos son inválidos, favor de llenar los campos faltantes ademas de acatar las observaciones'  unless @invalid_fields.empty?
  end


  def redirect_control 
    if @project.finish? and @project.invalid_revisions.empty?
        redirect_to project_finish_path(@project), notice: 'La evidencia del proyecto se guardo con èxito'
    else
      if  @project.finish? and !@project.invalid_revisions_person_documents.empty?
        redirect_to add_documents_people_path(@project), notice: 'La evidencia del proyecto se guardo con èxito'
      elsif @project.finish? and !@project.invalid_revisions_information.empty?
        redirect_to project_information_path(@project), notice: 'La evidencia del proyecto se guardo con èxito'
      elsif @project.finish?
        redirect_to project_evidence_path(@project), notice: 'La evidencia del proyecto se guardo con èxito'
      else
        yield
      end
    end
  end
end
