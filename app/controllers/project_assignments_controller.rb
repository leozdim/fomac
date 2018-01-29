class ProjectAssignmentsController < ApplicationController
  before_action :set_project_assignment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :project_assignment_params

  # GET /project_assignments
  # GET /project_assignments.json
  def index
    @project_assignments = ProjectAssignment.all
  end

  # GET /project_assignments/1
  # GET /project_assignments/1.json
  def show
    @judges = User.where(role: :judge, account_active: true)
  end

  # GET /project_assignments/new
  def new
    @project_assignment = ProjectAssignment.new
    @project_assignment.project_id = params[:project_id]
    @judges = User.where(role: :judge, account_active: true)
  end

  # GET /project_assignments/1/edit
  def edit
    @judges = User.where(role: :judge, account_active: true)
  end

  # POST /project_assignments
  # POST /project_assignments.json
  def create
    @project_assignment = ProjectAssignment.new(project_assignment_params)
    #@project_assignment.user_id = params[:user_id]
    respond_to do |format|
      if @project_assignment.save
        format.html { redirect_to project_path @project_assignment.project_id  }
        format.json { render :show, status: :created, location: @project_assignment }
      else
        format.html { render :new }
        format.json { render json: @project_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_assignments/1
  # PATCH/PUT /project_assignments/1.json
  def update
    project_assignment_params[:user_id] = params[:user_id]
    respond_to do |format|
      if @project_assignment.update(project_assignment_params)
        format.html { redirect_to project_path @project_assignment.project_id }
        format.json { render :show, status: :ok, location: @project_assignment }
      else
        format.html { render :edit }
        format.json { render json: @project_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_assignments/1
  # DELETE /project_assignments/1.json
  def destroy
    @project_assignment.destroy
    respond_to do |format|
      format.html { redirect_to project_assignments_url, notice: 'Project assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_assignment
      @project_assignment = ProjectAssignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_assignment_params
      params.require(:project_assignment).permit(:project_id, :user_id)
    end
end
