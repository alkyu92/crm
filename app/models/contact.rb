class Contact < ApplicationRecord
  has_many :relationships
  has_many :accounts, through: :relationships, source: :contactable, source_type: 'Account'
  has_many :opportunities, through: :relationships, source: :contactable, source_type: 'Opportunity'

  belongs_to :user

  validates :name, presence: true

  has_attached_file :profile_pic,
                    styles: { small: "43x43#", medium: "100x100>"},
                    default_url: "/images/:style/missing.png",
                    dependent: :destroy

  validates_attachment_content_type :profile_pic, content_type: /\Aimage\/.*\z/
end
