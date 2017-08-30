class Opportunity < ApplicationRecord
  belongs_to :user
  belongs_to :account

  has_many :relationships, as: :contactable
  has_many :contacts,   through: :relationships

  has_many :timelines,  as: :activity,    dependent: :destroy
  has_many :notes,      as: :info,        dependent: :destroy
  has_many :documents,  as: :attchdoc,    dependent: :destroy

  has_many :stages, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :calls, dependent: :destroy


  validates :name, presence: true

end
