class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_question, through: :subscriptions, source: :question
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :vkontakte]

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
  
  
  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info[:email] 
    email ||= "#{auth.uid}_temp@temp.com"
    email.downcase!
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create(email: email, password: password, password_confirmation: password)
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def temp_email?
    email =~ /temp@temp.com/
  end
  
  def author_of?(entity)
    entity.user_id == self.id
  end

  def vote(entity)
    self.votes.where(votable: entity).first
  end

  def voted?(entity)
    votes.where(votable: entity).exists?
  end

  def subscribe?(entity)
    subscriptions.where(question: entity).exists?
  end
end
