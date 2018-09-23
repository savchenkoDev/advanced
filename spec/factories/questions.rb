FactoryBot.define do
  factory :question do
    association :user, factory: :user
    title { "MyString" }
    body { "MyText" }
  end
  
  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
