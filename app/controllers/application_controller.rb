class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    path||=request.referer
    path||=session[:return_to]
    path||='/403.html'
    redirect_to  path, notice: 'No tienes acceso a esa pagina' 
  end

  protected  
  def after_sign_in_path_for(resource)
    if current_user.projects.any?
      # change this to hte active projects
       edit_project_path current_user.projects.first
    else
       new_project_path
    end
  end
end
