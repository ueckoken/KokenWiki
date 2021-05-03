class InvitationToken < ApplicationRecord
  belongs_to :created_by, class_name: "User"

  validates :token, presence: true, length: { minimum: 16, maximum: 1024 }
  validates :token, uniqueness: true
  validates :token, format: { without: URI::UNSAFE }

  def registration_path
    return Rails.application.routes.url_helpers.new_user_registration_path(t: token)
  end

  def expired?
    return expired_at < Time.now
  end
end
