class Contact < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :relationships, dependent: :destroy
  has_many :accounts, through: :relationships, source: :contactable, source_type: 'Account'

  has_many :opportunities, through: :relationships, source: :contactable, source_type: 'Opportunity'
  has_many :cases,  through: :relationships, source: :contactable, source_type: 'Case'
  has_many :marketings, through: :relationships, source: :contactable, source_type: 'Marketing'
  
  has_many :tasks, through: :relationships, source: :contactable, source_type: 'Task'
  has_many :calls, through: :relationships, source: :contactable, source_type: 'Call'
  has_many :events, through: :relationships, source: :contactable, source_type: 'Event'

  belongs_to :user

  validates :name, presence: true

  has_attached_file :profile_pic,
                    styles: { small: "43x43#", medium: "150x150>"},
                    default_url: "/images/:style/missing.png",
                    dependent: :destroy

  validates_attachment_content_type :profile_pic, content_type: /\Aimage\/.*\z/

  def country_name
    country = ISO3166::Country[mailing_country]
  end

  def self.search(query)
  __elasticsearch__.search(
    {
      query: {
        multi_match: {
          query: query,
          fields: [
            'name',
            'title',
            'department',
            'email',
            'phone',
            'fax'
          ]
        }
      },
      highlight: {
        pre_tags: ['<em>'],
        post_tags: ['</em>'],
        fields: {
          name: {},
          title: {},
          department: {},
          email: {},
          phone: {},
          fax: {}
        }
      }
    }
  )
end

end
