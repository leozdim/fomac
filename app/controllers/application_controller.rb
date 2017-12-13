class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  protected  
  def after_sign_in_path_for(resource)
    if current_user.projects.any?
      # change this to hte active project
       edit_project_path current_user.projects.first
    else
       new_project_path
    end
  end
end
