class StaticPagesController < ApplicationController
  load_and_authorize_resource :class => User


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
    @user = User.new(params.require(:user).permit(:first_name, :last_name, :second_last_name,:email,  :person_id))
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
      @project = Person.where(:project_id => params[:project]).first
  end

  def project
    @information = Information.where(:project_id => params[:project]).first
  end


end
