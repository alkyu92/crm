class Task < ApplicationRecord
  belongs_to :user
  belongs_to :opportunity
  validates :description, presence: true
end
