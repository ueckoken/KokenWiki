class UpdateHistory < ApplicationRecord
    belongs_to :user
    belongs_to :page
    validates :content, exclusion: { in: [nil]}
end
