class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
      alias_action :create, :update, to: :modify
      user ||= User.new # guest user (not logged in)
      case user.role
      when :admin
        can :read, :all
        return
      when :creator
        can :update, User 
        can :update, Project , id: user.projects.pluck(:id)
        can :add_people, Project , id: user.projects.pluck(:id)
        can :anexos, Project , id: user.projects.pluck(:id)
        can :add_documents_people, Project , id: user.projects.pluck(:id)
        can :create, Project
        can :update, Person, :project_id=>user.projects.pluck(:id) 
        can :create, Person
      when :reviewer
      when :judge
      end
      can :manage, User, id: user.id


    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
