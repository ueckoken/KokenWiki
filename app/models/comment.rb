class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :page

    validates :comment, exclusion: { in: [nil] }
end
