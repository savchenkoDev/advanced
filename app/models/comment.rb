class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true, touch: true
  belongs_to :user

  validates :text, presence: true, length: { minimum: 6 }
end