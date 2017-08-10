class Contact < ApplicationRecord
  belongs_to :opportunity
  belongs_to :user
end
