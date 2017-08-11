class Account < ApplicationRecord
  belongs_to :user

  has_many :acctimelines, dependent: :destroy
  has_many :opportunities, dependent: :destroy
  has_many :accdocuments, dependent: :destroy
  has_many :accnotes, dependent: :destroy
  has_many :acccontacts

  validates :account_name, presence: true
end
