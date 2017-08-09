class Account < ApplicationRecord
  belongs_to :user

  has_many :contacts
  has_many :acctimelines
  has_many :opportunities
end
