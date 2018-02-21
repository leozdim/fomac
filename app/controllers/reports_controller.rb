class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :report_params
  skip_load_resource only: [:download]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @proj = current_user.projects.first
    @docs=@report.report_doc

  end

  # GET /reports/new
  def new

    @report = Report.new
    @proj = current_user.projects.first
    @report.build_report_doc
    @report.project_id = @proj.id

  end

  # GET /reports/1/edit
  def edit
    @proj = current_user.projects.first

  end

  # POST /reports
  # POST /reports.json
  def create
    @proj = current_user.projects.first

    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to static_pages_reports_by_project_path }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report}
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url}
      format.json { head :no_content }
    end
  end

  def download
    if current_user.role==:creator

    end
    path = "#{Rails.root}/uploads/#{params[:class]}/#{params[:as]}/#{params[:id]}/#{params[:basename]}.#{params[:extension]}"
    if  File.exist?(path)
      send_file path, :x_sendfile=>true
    else
      redirect_to '/404.html'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.s
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:project_id, :year, :period, :number, :cuantitative, :qualitative, :activity, :programed_date, :real, :place, :number_people, :money_received,
                                     :report_doc_attributes=> [:id,:photos=>[], :video=>[], :document=>[],:payslips=>[], :press=>[], :publicity=>[]])
    end
end
