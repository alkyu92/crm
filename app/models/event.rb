class Event < ApplicationRecord
  belongs_to :opportunity
  validates :description, presence: true
end
