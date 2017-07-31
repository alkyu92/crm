class Opportunity < ApplicationRecord
  belongs_to :user
  has_many :stages, dependent: :destroy
end
