class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :activities
  has_many :opportunities
  has_many :accounts
  has_many :contacts

  has_many :timelines
  has_many :acctimelines
end
