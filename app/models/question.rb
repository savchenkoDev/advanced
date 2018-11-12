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
  after_create :create_subscription_for_author

  private
  
  def calculate_reputation
    CalculateReputationJob.perform_later(self)
  end

  def create_subscription_for_author
    self.subscriptions.create(user_id: self.user.id)
  end
end
