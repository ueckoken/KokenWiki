class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :page

  validates :comment, exclusion: { in: [nil] }, length: { minimum: 1 }
end
