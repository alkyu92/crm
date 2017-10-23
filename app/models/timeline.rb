class Timeline < ApplicationRecord
  belongs_to :activity, polymorphic: true
  belongs_to :user

  has_many :notifications, dependent: :destroy
end
