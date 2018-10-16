class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :votes
  has_many :comments
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(entity)
    entity.user_id == self.id
  end

  def vote(entity)
    self.votes.where(votable: entity).first
  end
  

  def voted?(entity)
    entity.votes.where(user_id: self.id).exists?
  end
end
