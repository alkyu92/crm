class Accnote < ApplicationRecord
  belongs_to :account
  belongs_to :user

  validates :title, presence: true
end
