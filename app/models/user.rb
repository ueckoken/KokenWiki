class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User
  has_and_belongs_to_many :usergroups
  has_many :create_groups, class_name: "Usergroup", foreign_key: "create_user_id"
  has_many :pages
  has_many :comments
  has_many :update_histories
  has_many :invitation_tokens, class_name: "InvitationToken", foreign_key: "created_by"
  before_create :skip_confirmation_in_dev

  has_one_attached :image



  validates :user_id, uniqueness: true, format: { with: /\A\w+\z/,
  message: "英数字,アンダーバーのみが使えます" }
  validates :email, uniqueness: true
  validates :name, length: { in: 1..50 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable, :trackable
  # devise token auth用に追加
  # devise :database_authenticatable, :registerable,
  #         :recoverable, :rememberable, :trackable, :validatable,
  #         :confirmable, :omniauthable

  def email_required?
    false
  end
  def email_changed?
    false
  end
  
  private
  def skip_confirmation_in_dev
    skip_confirmation! if Rails.env.development?
  end
end
