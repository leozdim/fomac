class ProjectMailer < ApplicationMailer

  def finish project
    @project=project
    @user=@project.user
    mail(to: @user.email, subject: 'Fin de registro FOMAC')
  end

  def observation rev
    @revision=rev
    @user=Project.where(:id => rev.project_id).first.user
    mail(to: @user.email, subject: 'Observaciones en proyecto FOMAC')
  end
end
