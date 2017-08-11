class Acccontact < ApplicationRecord
  belongs_to :account
  belongs_to :user

  has_attached_file :profile_pic,
                    styles: { small: "43x43#", medium: "100x100>"},
                    default_url: "/images/:style/missing.png",
                    dependent: :destroy

  validates_attachment_content_type :profile_pic, content_type: /\Aimage\/.*\z/
end
