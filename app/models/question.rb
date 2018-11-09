class Question < ApplicationRecord
  include Votable
  include Attachable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true, length: { minimum: 6 }

  after_create :calculate_reputation

  private
  
  def calculate_reputation
    CalculateReputationJob.perform_later(self)
  end
end
