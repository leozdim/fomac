class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    path||=request.referer
    path||=session[:return_to]
    path||='/403.html'
    redirect_to  path, notice: 'No tienes acceso a esa pagina' 
  end

  protected  
  def after_sign_in_path_for(resource)
    if current_user.role == :admin
      projects_path
    else
      if current_user.projects.any?
        # change this to hte active projects
        p=current_user.projects.first
        if p.finish?
          project_finish_path(p)
        else
          nav_project
        end
      else
        new_project_path
      end
    end
  end
end
