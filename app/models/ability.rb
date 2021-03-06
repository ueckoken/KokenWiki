# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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

    # can :read, Page
    # cannot :read, Page

    alias_action :update, :destroy, to: :write

    # A user who is not logged in cannot do anything but logging in
    unless user.present?
      return
    end

    can :read, :setting
    can :read, Page, readable_group: nil
    can :read, Page, readable_group: { id: user.usergroup_ids }
    can [:read, :create], Usergroup
    can :create, Page, parent: nil, title: "" # root page
    can :create, Page, parent: { editable_group: nil }
    can :create, Page, parent: { editable_group: { id: user.usergroup_ids } }
    can :write, Page, editable_group: nil
    can :write, Page, editable_group: { id: user.usergroup_ids }
    can :write, Comment, user_id: user.id
    can :write, Usergroup, users: { id: user.id }

    if user.is_admin?
      can :manage, Page
      can :manage, Comment
      can :manage, Usergroup
      can :manage, User
      can :manage, InvitationToken
      can :manage, :userlock
      can :manage, :admin_user
    end
  end
end
