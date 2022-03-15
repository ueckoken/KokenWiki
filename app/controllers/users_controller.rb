class UsersController < ApplicationController
  layout "settings"

  def index
    if cannot?(:manage, :userlock) || cannot?(:manage, :userprivilege)
      raise CanCan::AccessDenied
      return
    end
    @users = User.all.order(is_admin: :desc).order(locked_at: :asc)
  end
end
