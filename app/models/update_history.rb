class UpdateHistory < ApplicationRecord
    belongs_to :user
    belongs_to :page
end
