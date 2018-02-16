class SelectedProjectsController < ApplicationController
  before_action :set_selected_project, only: [:show, :edit, :update, :destroy]

  # GET /selected_projects
  # GET /selected_projects.json
  def index
    @selected_projects = SelectedProject.all
  end

  # GET /selected_projects/1
  # GET /selected_projects/1.json
  def show
  end

  # GET /selected_projects/new
  def new
    @selected_project = SelectedProject.new
  end

  # GET /selected_projects/1/edit
  def edit
  end

  # POST /selected_projects
  # POST /selected_projects.json
  def create
    @selected_project = SelectedProject.new(selected_project_params)

    respond_to do |format|
      if @selected_project.save
        format.html { redirect_to @selected_project, notice: 'Selected project was successfully created.' }
        format.json { render :show, status: :created, location: @selected_project }
      else
        format.html { render :new }
        format.json { render json: @selected_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /selected_projects/1
  # PATCH/PUT /selected_projects/1.json
  def update
    respond_to do |format|
      if @selected_project.update(selected_project_params)
        format.html { redirect_to @selected_project, notice: 'Selected project was successfully updated.' }
        format.json { render :show, status: :ok, location: @selected_project }
      else
        format.html { render :edit }
        format.json { render json: @selected_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /selected_projects/1
  # DELETE /selected_projects/1.json
  def destroy
    @selected_project.destroy
    respond_to do |format|
      format.html { redirect_to selected_projects_url, notice: 'Selected project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_selected_project
      @selected_project = SelectedProject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def selected_project_params
      params.require(:selected_project).permit(:project_id)
    end
end
