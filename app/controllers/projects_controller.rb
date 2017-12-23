class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :project_params
  skip_load_resource only: [:download]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end


  def add_people
    if request.patch?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to add_anexo_people_path(@project), notice: 'Person was successfully updated.' }
          format.json { render :show, status: :ok, location: @person }
        else
          format.html { render :edit }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    else
      @project.people.build if @project.people.empty?
    end
  end

  def anexos
  end

  def add_documents_people
    if request.patch?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to project_information_path(@project), notice: 'Person was successfully updated.' }
        else
          format.html { render :add_documents_people }
        end
      end
    end
  end

  def information
    if request.patch?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to project_retribution_path(@project), notice: 'Person was successfully updated.' }
          format.json { render :show, status: :ok, location: @person }
        else
          format.html { render :edit }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    else
      @project.information=Information.new if @project.information.blank?
    end
  end 

  def retribution 
    if request.patch?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to project_evidence_path(@project), notice: 'Person was successfully updated.' }
          format.json { render :show, status: :ok, location: @person }
        else
          format.html { render :edit }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    else
      if @project.retribution.blank?
        retribution= Retribution.new
        retribution.modality=Modality.order(:name).first
        retribution.art_activity=ArtActivity.order(:name).first
        @project.retribution=retribution
      end
    end
  end

  def evidence
    if request.patch?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to project_evidence_path(@project), notice: 'Person was successfully updated.' }
          format.json { render :show, status: :ok, location: @person }
        else
          format.html { render :edit }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    else
      @project.visual_evidence=VisualEvidence.new if @project.visual_evidence.blank?
      @project.dance_evidence=DanceEvidence.new if @project.dance_evidence.blank?
      @project.music_evidence=MusicEvidence.new if @project.music_evidence.blank?
      @project.theater_evidence=TheaterEvidence.new if @project.theater_evidence.blank?
      @project.film_evidence=FilmEvidence.new if @project.film_evidence.blank?
      @project.letter_evidence=LetterEvidence.new if @project.letter_evidence.blank?
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
        format.html { redirect_to add_project_people_path(@project), notice: 'Project was successfully created.' }
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
        format.html { redirect_to add_project_people_path(@project), notice: 'Project was successfully updated.' }
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
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
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
                                    [ :street, :internal_number, :external_number, :colony, :zip ],
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
