class ProjectMailer < ApplicationMailer

  def finish project
    @project=project
    @user=@project.user
    mail(to: @user.email, subject: 'Fin de registro FOMAC')
  end
end
