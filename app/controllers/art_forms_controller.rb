class ArtFormsController < ApplicationController
  before_action :set_art_form, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /art_forms
  # GET /art_forms.json
  def index
    @art_forms = ArtForm.all
  end

  # GET /art_forms/1
  # GET /art_forms/1.json
  def show
  end

  # GET /art_forms/new
  def new
    @art_form = ArtForm.new
  end

  # GET /art_forms/1/edit
  def edit
  end

  # POST /art_forms
  # POST /art_forms.json
  def create
    @art_form = ArtForm.new(art_form_params)

    respond_to do |format|
      if @art_form.save
        format.html { redirect_to @art_form, notice: 'Art form was successfully created.' }
        format.json { render :show, status: :created, location: @art_form }
      else
        format.html { render :new }
        format.json { render json: @art_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /art_forms/1
  # PATCH/PUT /art_forms/1.json
  def update
    respond_to do |format|
      if @art_form.update(art_form_params)
        format.html { redirect_to @art_form, notice: 'Art form was successfully updated.' }
        format.json { render :show, status: :ok, location: @art_form }
      else
        format.html { render :edit }
        format.json { render json: @art_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /art_forms/1
  # DELETE /art_forms/1.json
  def destroy
    @art_form.destroy
    respond_to do |format|
      format.html { redirect_to art_forms_url, notice: 'Art form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_art_form
      @art_form = ArtForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def art_form_params
      params.require(:art_form).permit(:name, :active)
    end
end
