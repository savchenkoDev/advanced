class SingleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :created_at, :updated_at

  has_many :comments
  has_many :attachments

  def comments
    object.comments.order(id: :asc)
  end

  def attachments
    object.attachments.order(id: :asc)
  end
end
