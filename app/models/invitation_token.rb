class InvitationToken < ApplicationRecord
  belongs_to :created_by, class_name: "User"
  has_secure_token length: 36

  def registration_path
    return Rails.application.routes.url_helpers.new_user_registration_path(t: token)
  end

  def expired?
    return expired_at < Time.now
  end
end
