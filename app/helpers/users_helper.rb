module UsersHelper
  def getUsers
    if current_user.role == :judge
      User.where(role: :creator)
    else
      User.all
    end
  end
end
