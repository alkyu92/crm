class User < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar,
                    styles: {medium: "300x300#", small: "25x25#", noty: "40x40#"},
                    default_url: "/images/:style/missing.png",
                    dependent: :destroy

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  has_many :opportunities
  has_many :accounts

  has_many :contacts
  has_many :notes

  has_many :stages

  has_many :timelines

  has_many :tasks
  has_many :calls
  has_many :events

  has_many :notifications
end
