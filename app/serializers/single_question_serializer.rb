class SingleQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at
  has_many :attachments
  has_many :comments

  def attachments
    object.attachments.order(id: :asc)
  end
  def comments
    object.comments.order(id: :asc)
  end
end
