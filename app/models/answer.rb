class Answer < ApplicationRecord
  include Votable
  include Attachable
  include Commentable
  
  belongs_to :question, touch: true
  belongs_to :user

  validates :body, presence: true, length: { minimum: 6 }

  scope :by_best, -> { order(best: :desc) }

  def set_best
    transaction do 
      question.answers.update_all(best: false)
      update!(best: true)
    end  
  end

  after_create :calculate_reputation
  after_create :send_notify

  private
  
  def calculate_reputation
    CalculateReputationJob.perform_later(self)
  end

  def send_notify
    NewAnswerNotificationJob.perform_later(self)
  end
end
