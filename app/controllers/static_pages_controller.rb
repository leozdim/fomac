class StaticPagesController < ApplicationController
  load_and_authorize_resource :class => User
  include ProjectsHelper

  def home
    @user = User.new
  end



  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def savenew
    @user = User.new(params.require(:user).permit(:first_name, :last_name, :second_last_name,:email,:account_active,  :person_id))
    @user.password = "123456"
    @user.role = params[:role]
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :home }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def creator
    @person = Person.where(:project_id => params[:project]).first
    @project = Project.where(:id=> params[:project]).first
  end

  def project
    @information = Information.where(:project_id => params[:project]).first
    @project = Project.where(:id=> params[:project]).first

  end

  def project_scores
    @test = []
    @zero = []
    @projects = Project.where(:id => ProjectAssignment.select(:project_id).map(&:project_id))

    @projects.each do |p|
        @test.push({:score =>get_score(p.id).to_f,:pro => p,:selected=>false})
    end
    @test.sort_by{|e| e[:pro]}

  end

  def privacy

  end


  def evidence
    @information = Information.where(:project_id => params[:project]).first
    @project = Project.where(:id=> params[:project]).first

    @arts=@project.art_forms

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
