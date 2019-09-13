class User < ApplicationRecord
  has_many :user_usergroups
  has_many :usergroups, through: :user_usergroups
  
  has_many :pages
  has_many :comments
  has_many :update_histories

  has_one_attached :image


  validates :user_id, uniqueness: true
  validates :email, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable
end
