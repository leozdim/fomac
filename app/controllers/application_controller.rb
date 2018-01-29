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
    if current_user.role == :admin or current_user.role == :judge
      projects_path
    else
      if current_user.projects.any?
        # change this to hte active projects
        p=current_user.projects.first
        if p.finish?
          if p.is_valid?  || p.invalid_revisions.blank?#or in revision all :D or all pending
            project_finish_path(p)
          else
            if !p.revisions_information.blank?
              #check revision to see where to link
              project_information_path p
            elsif  !p.revisions_persondoc.blank?
              add_documents_people_path p
            elsif  !p.revisions_film_evidence.blank? || !p.revisions_music_evidence.blank? ||!p.revisions_dance_evidence.blank?  ||!p.revisions_letter_evidence.blank?  || !p.revisions_theater_evidence.blank? || !p.revisions_visual_evidence.blank?
              project_evidence_path p
            end
          end
        else
          nav_project
        end
      else
        new_project_path
      end
    end
  end
end
