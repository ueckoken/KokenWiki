class Page < ApplicationRecord
    belongs_to :user
    belongs_to :editable_group, class_name: "Usergroup", optional: true
    belongs_to :readable_group, class_name: "Usergroup", optional: true

    has_many :children, class_name: "Page",
                          foreign_key: "parent_id"
 
    belongs_to :parent, class_name: "Page", optional: true

    has_many :update_histories
    has_many :comments

    has_many_attached :files

    validates :path, uniqueness: true, exclusion: { in: [nil] }
    validates :title, exclusion: { in: [nil] }, format: {with: /\A[^?\.]*\z/}
    validates :path, format: { with: /\A[^?\.]*\z/}
    validates :content, exclusion: { in: [nil]}


end
