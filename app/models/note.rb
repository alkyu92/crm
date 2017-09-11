class Note < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :info, polymorphic: true
  belongs_to :user

  validates :title, presence: true

end
