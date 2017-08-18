class Note < ApplicationRecord
  belongs_to :info, polymorphic: true
  
  belongs_to :user

  validates :title, presence: true
end
