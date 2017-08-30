class Account < ApplicationRecord
  belongs_to :user

  has_many :relationships, as: :contactable
  has_many :contacts, through: :relationships

  has_many :timelines,  as: :activity,    dependent: :destroy
  has_many :notes,      as: :info,        dependent: :destroy
  has_many :documents,  as: :attchdoc,    dependent: :destroy

  has_many :opportunities, dependent: :destroy

  validates :account_name, presence: true
end
