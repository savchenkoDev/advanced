class Answer < ApplicationRecord
  include Votable
  include Attachable
  include Commentable
  
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 6 }

  scope :by_best, -> { order(best: :desc) }

  after_create :calculate_reputation

  def set_best
    transaction do 
      question.answers.update_all(best: false)
      update!(best: true)
    end  
  end

  private

  def calculate_reputation
    Reputation.delay.calculate(self)
  end
  
end
