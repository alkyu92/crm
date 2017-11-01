class Note < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user
  belongs_to :info, polymorphic: true

  validates :title, presence: true

end
