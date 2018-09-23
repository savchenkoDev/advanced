FactoryBot.define do
  factory :answer do
    association :user, factory: :user
    association :question, factory: :question
    body { "MyText" }
  end

  factory :invalid_answer, class: Answer do
    association :user, factory: :user
    association :question, factory: :question
    question_id nil
    body nil
  end
end
