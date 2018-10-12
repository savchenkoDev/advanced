class Question < ApplicationRecord
  include Votable
  include Attachable
  
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true, length: { minimum: 6 }

end
