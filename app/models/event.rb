class Event < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  belongs_to :user
  belongs_to :opportunity
  validates :description, presence: true
end
