class Account < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user

  has_many :relationships, as: :contactable
  has_many :contacts, through: :relationships

  has_many :timelines,  as: :activity,    dependent: :destroy
  has_many :notes,      as: :info,        dependent: :destroy
  has_many :documents,  as: :attchdoc,    dependent: :destroy

  has_many :opportunities, dependent: :destroy

  validates :account_name, presence: true

  def self.search(query)
  __elasticsearch__.search(
    {
      query: {
        multi_match: {
          query: query,
          fields: [
            'account_name'
          ]
        }
      },
      highlight: {
        pre_tags: ['<em>'],
        post_tags: ['</em>'],
        fields: {
          account_name: {}
        }
      }
    }
  )
end
end
