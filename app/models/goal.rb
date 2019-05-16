class Goal < ApplicationRecord
  validates :title, :body, :cheers, presence: true

  belongs_to :user
end

