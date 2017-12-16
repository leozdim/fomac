class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :project_params

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
          format.json { render :show, status: :ok, location: @person }
        else
          format.html { render :edit }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    else
      @project.people.first.person_document=PersonDocument.new if @project.people.first.person_document.blank?
    end
  end

  def information
    if request.patch?
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to project_information_path(@project), notice: 'Person was successfully updated.' }
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
                                    :information_attributes=> [:id,:name,:description,:antecedent,:justification,:general_objective,:specific_objective,:goals,:beneficiary,:context,:bibliography,:activities,:spending,:funding])

  end 
end
