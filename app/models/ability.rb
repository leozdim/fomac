class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
      alias_action :create, :update, to: :modify
      user ||= User.new # guest user (not logged in)
      case user.role
      when :admin
        can :read,:all
        can  :update,:all
        can :modify, :all
        can :manage,  :all
        return
      when :creator
        projects=user.projects.pluck(:id)
        can :update, Project , id: projects
        can :add_people, Project , id: projects
        can :anexos, Project , id: projects
        can :add_documents_people, Project , id: projects
        can :information, Project , id: projects
        can :retribution, Project , id: projects
        can :evidence, Project , id: projects
        can :finish, Project , id: projects
        can :create, Project
        can :update, Person, :project_id=>projects
        can :create, Person
        can :create, Report
      when :reviewer
      when :judge
        can :read,:all
        can  :update,:all
        can :modify, :all
        can :manage,  :all
        return
      end
      can :manage, User, id: user.id
      can :download, Project
      can :download, Report



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
