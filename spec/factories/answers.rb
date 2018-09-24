FactoryBot.define do
  factory :answer do
    user
    question
    body { "MyText" }
  end
end
