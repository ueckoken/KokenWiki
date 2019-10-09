class User < ApplicationRecord
  has_many :user_usergroups
  has_many :usergroups, through: :user_usergroups

  
  has_many :create_groups, class_name: "Usergroup", foreign_key: "create_user_id"
  
  
  has_many :pages
  has_many :comments
  has_many :update_histories

  has_one_attached :image

  

  validates :user_id, uniqueness: true, format: { with: /\A\w+\z/,
  message: "英数字,アンダーバーのみが使えます" }
  validates :email, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable, :trackable
  
  def email_required?
    false
  end
  def email_changed?
    false
  end
end
