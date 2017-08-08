class Note < ApplicationRecord
  belongs_to :opportunity

  validates :title, presence: true
end
