class Stage < ApplicationRecord
  belongs_to :user
  belongs_to :polystage, polymorphic: true

  validates :name, presence: true
end
