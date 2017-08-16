class Note < ApplicationRecord
  belongs_to :opportunity
  belongs_to :user

  validates :title, presence: true
end
