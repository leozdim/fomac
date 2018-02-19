module ProjectsHelper

  def get_status(field, model)
     test = Revision.where(user_id: @project.user.id, project_id: @project.id, field: field, model: model).order(:created_at).first
     test.blank? ? "Pendiente" : test.status
  end

  def get_observation_id(field, model)
    test = Revision.where(user_id: @project.user.id, project_id: @project.id, field: field, model: model).order(:created_at).first
    test.blank? ? "" : test.id
  end

  def get_project_ids
    if current_user.role == :judge
      ids = Project.where(id: ProjectAssignment.where(user_id: current_user.id).pluck(:project_id)).pluck(:id)
    else
      ids = Project.all.pluck(:id)
    end
      ids
  end


  def get_score(id)
    eva =  Evaluation.where(project_assignment_id: ProjectAssignment.where(project_id: id).first.id).first
    if !eva.blank?
      result = (eva.clarity_value.to_i+eva.creativity_value.to_i+eva.excellence_value.to_i+eva.feasibility_value.to_i+eva.impact_value.to_i+eva.innovation_value.to_i+eva.justification_value.to_i+eva.originality_value.to_i+eva.schema_value.to_i+eva.timeframe_value.to_i)
    else
      result =  0
    end
    result != 0 ? result/10.0: result
  end

  def get_evaluation(id)
    Evaluation.where(project_assignment_id: ProjectAssignment.where(project_id: id).first.id).first
  end

  def get_judge(projectId)
    judge = ProjectAssignment.where(project_id: projectId).first
  end

  def get_observation(field, model)
    test = Revision.where(user_id: @project.user.id, project_id: @project.id, field: field, model: model).order(:created_at).first
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
