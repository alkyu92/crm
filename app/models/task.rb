class Task < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user
  belongs_to :polytask, polymorphic: true

  has_many :relationships, as: :contactable, dependent: :destroy
  has_many :contacts, through: :relationships

  validates :description, presence: true

end
