class Document < ApplicationRecord
  belongs_to :attchdoc, polymorphic: true

  has_attached_file :doc,
                    styles: { thumb: "200x250#" },
                    default_url: "/images/:style/missing.png",
                    dependent: :destroy

  validates_attachment_content_type :doc,
  content_type: [
    "application/pdf",
    "application/vnd.ms-excel",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "application/msword",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "text/plain",
    "image/jpg",
    "image/jpeg",
    "image/png",
    "image/gif"
  ]
end
