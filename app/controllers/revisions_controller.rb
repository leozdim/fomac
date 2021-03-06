class RevisionsController < ApplicationController
  before_action :set_revision, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
 load_and_authorize_resource param_method: :revision_params

  # GET /revisions
  # GET /revisions.json
  def index
    @revisions = Revision.all
  end

  # GET /revisions/1
  # GET /revisions/1.json
  def show
  end

  # GET /revisions/new
  def new
    id = get_observation_id(params[:field])
    if id != ""
      @revision = Revision.where(id: id).first
      @revision.observations = ""
    else
      @revision = Revision.new()
    end
    @revision.user_id= params[:user_id]
    @revision.project_id= params[:project_id]
    @revision.field= params[:field]
    @revision.status= params[:status]
    @revision.model = params[:model]
    if params[:status] == "Valido"
      respond_to do |format|
        if @revision.save
          format.html { redirect_to project_path(params[:project_id]) }
          format.json { render :show, status: :created, location: @revision }
        else
          format.html { render :new }
          format.json { render json: @revision.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET /revisions/1/edit
  def edit
  end

  # POST /revisions
  # POST /revisions.json
  def create
    @revision = Revision.new(revision_params)
    respond_to do |format|
      if @revision.save
        ProjectMailer.observation(@revision).deliver_now
        format.html { redirect_to project_path @revision.project_id }
        format.json { render :show, status: :created, location: @revision }
      else
        format.html { render :new }
        format.json { render json: @revision.errors, status: :unprocessable_entity }
      end
    end
  end

  def validate
    @revision = Revision.new()
    @revision.user_id= params[:user_id]
    @revision.project_id= params[:project_id]
    @revision.field= params[:field]
    @revision.status= "Valido"
    respond_to do |format|
      if @revision.save
        format.html { redirect_to project_path(params[:project_id]) }
        format.json { render :show, status: :created, location: @revision }
      else
        format.html { render :new }
        format.json { render json: @revision.errors, status: :unprocessable_entity }
      end
    end

  end

  def observation()
    @revision = Revision.new

  end

  # PATCH/PUT /revisions/1
  # PATCH/PUT /revisions/1.json
  def update
    respond_to do |format|
      if @revision.update(revision_params)
        format.html { redirect_to project_path @revision.project_id   }
        format.json { render :show, status: :ok, location: @revision }
      else
        format.html { render :edit }
        format.json { render json: @revision.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /revisions/1s
  # DELETE /revisions/1.json
  def destroy
    @revision.destroy
    respond_to do |format|
      format.html { redirect_to project_path @revision.project_id }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_revision
      @revision = Revision.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def revision_params
      params.require(:revision).permit(:user_id, :project_id, :field, :status, :model,:observations)
    end

    def get_observation_id(field)
      test = Revision.where(user_id: params[:user_id], project_id: params[:project_id], field: params[:field], model: params[:model]).order(:created_at).first
      test.blank? ? "" : test.id
    end

end
