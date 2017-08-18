class Account < ApplicationRecord
  belongs_to :user

  has_many :contacts,   as: :assignment
  has_many :timelines,  as: :activity,    dependent: :destroy
  has_many :notes,      as: :info,        dependent: :destroy
  has_many :documents,  as: :attchdoc,    dependent: :destroy

  has_many :opportunities, dependent: :destroy
  
  validates :account_name, presence: true
end
