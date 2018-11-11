class Question < ApplicationRecord
  include Votable
  include Attachable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, :body, presence: true, length: { minimum: 6 }

  after_create :calculate_reputation

  private
  
  def calculate_reputation
    CalculateReputationJob.perform_later(self)
  end
end
