class Opportunity < ApplicationRecord
  belongs_to :user

  has_many :stages, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :calls, dependent: :destroy
  has_many :timelines, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :documents, dependent: :destroy

  serialize :contacts, Array
end
