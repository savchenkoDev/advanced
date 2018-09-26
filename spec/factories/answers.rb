FactoryBot.define do
  sequence :body do |n|
    "Answer#{n}"
  end

  factory :answer do
    user
    question
    body
  end
  
  factory :invalid_answer, class: Answer do
    user
    question
    body { nil }
  end
end
