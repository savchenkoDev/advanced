FactoryBot.define do
  sequence :title do |n|
    "Question Title #{n}"
  end

  sequence :question_body do |n|
    "Question Body #{n}"
  end

  factory :question do
    user
    title
    body { generate(:question_body) }
  end
  
  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
