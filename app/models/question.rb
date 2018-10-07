class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  validates :title, :body, presence: true, length: { minimum: 6 }

  accepts_nested_attributes_for :attachments
end
