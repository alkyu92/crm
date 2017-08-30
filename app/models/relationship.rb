class Relationship < ApplicationRecord
  belongs_to :contact
  belongs_to :contactable, polymorphic: true
end
