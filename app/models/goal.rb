class Goal < ApplicationRecord
  validates :title, :body, :cheers, presence: true

  belongs_to :user

  has_many :comments, 
    as: :commentable,
    dependent: :destroy
end

