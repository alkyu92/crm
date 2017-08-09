class Accdocument < ApplicationRecord
  belongs_to :account

  has_attached_file :accdoc,
                    styles: { thumb: "200x250#" },
                    default_url: "/images/:style/missing.png",
                    dependent: :destroy

  validates_attachment_content_type :accdoc,
  content_type: ["application/pdf","application/vnd.ms-excel",
 "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
 "application/msword",
 "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
 "text/plain"]
end
