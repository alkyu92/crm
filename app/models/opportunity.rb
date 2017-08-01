class Opportunity < ApplicationRecord
  belongs_to :user

  has_many :stages, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :calls, dependent: :destroy
end
