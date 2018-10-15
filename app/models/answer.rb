class Answer < ApplicationRecord
  include Votable
  include Attachable
  
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 6 }

  scope :by_best, -> { order(best: :desc) }

  def set_best
    transaction do 
      question.answers.update_all(best: false)
      update!(best: true)
    end  
  end
end
