class User < ApplicationRecord
  has_and_belongs_to_many :usergroups
  has_many :create_groups, class_name: "Usergroup", foreign_key: "create_user_id"
  has_many :pages
  has_many :comments
  has_many :update_histories
  has_many :invitation_tokens, class_name: "InvitationToken", foreign_key: "created_by"

  has_one_attached :image



  validates :user_id, uniqueness: true, format: { with: /\A\w+\z/,
  message: "英数字,アンダーバーのみが使えます" }
  validates :email, uniqueness: true
  validates :name, length: { in: 1..50 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable, :trackable,
         :omniauthable, omniauth_providers: %i[keycloakopenid]
  def email_required?
    false
  end
  def email_changed?
    false
  end
end
