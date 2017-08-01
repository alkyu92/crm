class Timeline < ApplicationRecord
  belongs_to :opportunity
  belongs_to :user
end
