class Answer < ApplicationRecord
  has_one :question

  validates :title, :body, presence: true, length: { minimum: 6 }
  validates :question_id, presence: true, numericality: { only_integer: true }
end
