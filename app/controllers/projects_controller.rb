class ProjectsController < ApplicationController
  include ProjectsHelper
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :project_params
  skip_load_resource only: [:download]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
    respond_to do |format|
      format.html
      format.json { render json: ProjectDatatable.new(view_context) }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @arts=@project.art_forms

  end

  # GET /projects/new
  def new
    final_path=after_sign_in_path_for current_user
    return redirect_to final_path unless request.path== final_path
    @project = Project.new
  end

  def finish 
    unless @project.finish?
      redirect_to edit_project_path(@project), notice: 'Aùn no terminas de dar de alta el proyeto'
    else
      ProjectMailer.finish(@project).deliver_later
    end


  end 

  # GET /projects/1/edit
  def edit
  end


  def add_people
    if request.patch?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to add_anexo_people_path(@project), notice: 'Lo(s) participante(s) del proyecto se guardo con èxito'  }
        else
          format.html { render :add_people }
        end
      end
    else
      @project.people.build if @project.people.empty?
    end
  end

  def anexos
  end

  def add_documents_people
    check_revisions 'person_documents'
    if request.patch?
      if @project.update(project_params)
        if  @invalid_fields
          @project.invalid_revisions_person_documents.update_all status: 'Revision'
        end
        redirect_control { redirect_to project_information_path(@project), notice: 'La documentaciòn del proyecto se guardo con èxito'  }
      else
        render :add_documents_people 
      end
    end
  end

  def information
    if request.patch?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to project_retribution_path(@project), notice: 'La Información del proyecto se guardo con èxito' }
        else
          format.html { render :information }
        end
      end
    else
      @project.build_information if @project.information.blank?
    end
  end 

  def retribution 
    if request.patch?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to project_evidence_path(@project), notice: 'La retribuciòn del proyecto se guardo con èxito' }
        else
          format.html { render :retribution }
        end
      end
    else
      if @project.retribution.blank?
        @project.build_retribution
        retribution= @project.retribution
        retribution.modality=Modality.order(:name).first
        retribution.art_activity=ArtActivity.order(:name).first
      end
    end
  end

  def evidence
    @arts=@project.art_forms
    check_revisions [ 'visual_evidence','dance_evidence',
                      'music_evidence','theater_evidence',
                      'film_evidence','letter_evidence' ]
    if request.patch?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to project_finish_path(@project), notice: 'La evidencia del proyecto se guardo con èxito'  }
        else
          format.html { render :evidence }
        end
      end
    else
      @arts.each do |a|
        @project.build_visual_evidence if @project.visual_evidence.blank? and VisualEvidence::ART_FORM_ID==a.id
        @project.build_dance_evidence if @project.dance_evidence.blank? and DanceEvidence::ART_FORM_ID==a.id
        @project.build_music_evidence if @project.music_evidence.blank? and MusicEvidence::ART_FORM_ID==a.id
        @project.build_theater_evidence if @project.theater_evidence.blank? and TheaterEvidence::ART_FORM_ID==a.id
        @project.build_film_evidence if @project.film_evidence.blank? and FilmEvidence::ART_FORM_ID==a.id
        @project.build_letter_evidence if @project.letter_evidence.blank? and LetterEvidence::ART_FORM_ID==a.id
      end
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user=current_user
    @project.art_forms=ArtForm.find params[:project][:art_forms].reject!(&:blank?)
    respond_to do |format|
      if @project.save
        format.html { redirect_to add_project_people_path(@project), notice: 'El proyecto se guardo con èxito'  }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @project = Project.find(params[:id])
    @project.category_id=project_params[:category_id]
    @project.art_forms=ArtForm.find params[:project][:art_forms].reject!(&:blank?)
    respond_to do |format|
      if @project.save
        format.html { redirect_to add_project_people_path(@project), notice: 'El proyecto se guardo con èxito' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'La Información del proyecto fue guarda con èxito'  }
      format.json { head :no_content }
    end
  end

  def download
    if current_user.role==:creator
      access=params[:class].camelize.constantize.joins(:project).where('projects.user_id'=>current_user.id, :id=>params[:id]).count
      if access==0
        raise CanCan::AccessDenied.new("No tienes acceso")
      end
    end
    path = "#{Rails.root}/uploads/#{params[:class]}/#{params[:as]}/#{params[:id]}/#{params[:basename]}.#{params[:extension]}"
    if  File.exist?(path)
      send_file path, :x_sendfile=>true
    else
      redirect_to '/404.html' 
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params 
    params.require(:project).permit( :category_id ,:people_attributes=>
                                    [ :id,:first_name, :last_name, :second_last_name, :birthdate, :home_phone_number, :cellphone, :birthplace, :state, :city, :nationality, :level_study, :birthdate, 
                                      :addresses_attributes=>
                                    [ :id , :street, :internal_number, :external_number, :colony, :zip ],
                                      :person_document_attributes=>[:id,:request_letter,:birth,:address,:identification,:curp,:resume,:kardex,:agreement_letter,:assign_letter]],
                                    :information_attributes=> [:id,:name,:description,:antecedent,:justification,:general_objective,:specific_objective,:goals,:beneficiary,:context,:bibliography,:activities,:spending,:funding],
                                   :retribution_attributes=> [:id, :modality_id, :art_activity_id, :description],
                                   :visual_evidence_attributes=> [:id, :image=>[], :catalog=>[], :note=>[], :document=>[]],
                                   :dance_evidence_attributes=> [:id,:video, :web , :image=>[], :note=>[], :document=>[]],
                                   :music_evidence_attributes=> [:id,:video, :web , :audio, :score=>[], :note=>[], :document=>[]],
                                   :theater_evidence_attributes=> [:id,:video, :web , :script, :letter, :image=>[], :note=>[], :document=>[]],
                                   :film_evidence_attributes=> [:id,:video, :web , :demo, :script, :plan, :synopsis, :letter],
                                   :letter_evidence_attributes=> [:id, :web , :work, :cover=>[] ])

  end 
end
