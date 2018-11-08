class Question < ApplicationRecord
  include Votable
  include Attachable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true, length: { minimum: 6 }

  after_create :update_reputation

  def calculate_reputation
    reputation = Reputation.calculate(self)
    self.user.update(reputation: reputation)
  end

  private

  def update_reputation
    self.delay.calculate_reputation
  end
  

end
