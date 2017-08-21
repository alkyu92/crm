class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar,
                    styles: {medium: "200x200#", small: "25x25#"},
                    default_url: "/images/:style/missing.png",
                    dependent: :destroy

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  has_many :opportunities
  has_many :accounts

  has_many :contacts
  has_many :notes

  has_many :timelines

  has_many :tasks
  has_many :calls
  has_many :events

  has_many :notifications, dependent: :destroy
end
