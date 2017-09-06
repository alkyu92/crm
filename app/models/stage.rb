class Stage < ApplicationRecord
  belongs_to :user
  belongs_to :opportunity
  
  validates :name, presence: true
end
