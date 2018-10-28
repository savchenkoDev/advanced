FactoryBot.define do
  factory :comment, class: Comment do
    association :commentable, factory: :question
    text { "Comment text"}
    user
  end

  factory :question_comment, class: Comment do
    association :commentable, factory: :question
    commentable_type 'Question'
    text { "Question's comment text"}
    user
  end

  factory :answer_comment, class: Comment do
    association :commentable, factory: :question
    commentable_type 'Answer'
    text { "Answer's comment text"}
    user
  end
end
