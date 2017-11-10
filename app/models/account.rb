class Account < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user

  has_many :relationships, as: :contactable, dependent: :destroy
  has_many :contacts, through: :relationships

  has_many :timelines,  as: :activity,    dependent: :destroy
  has_many :notes,      as: :info,        dependent: :destroy
  has_many :documents,  as: :attchdoc,    dependent: :destroy
  has_many :opportunities,                dependent: :destroy
  has_many :cases,                        dependent: :destroy
  has_many :marketings,                   dependent: :destroy

  validates :name, presence: true

  def country_name(column_name)
    country = ISO3166::Country[column_name]
  end

  def self.search(query)
  __elasticsearch__.search(
    {
      query: {
        multi_match: {
          query: query,
          fields: [
            'name'
          ]
        }
      },
      highlight: {
        pre_tags: ['<em>'],
        post_tags: ['</em>'],
        fields: {
          name: {}
        }
      }
    }
  )
end
end
