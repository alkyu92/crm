class Stage < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  belongs_to :user
  belongs_to :opportunity

  validates :name, presence: true
end
