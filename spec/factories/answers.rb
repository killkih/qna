FactoryBot.define do
  factory :answer do
    body { "Answer text" }
    association :question, factory: :question

    trait :invalid do
      body { nil }
    end
  end
end
