# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'Answer text' }
    association :question, factory: :question
    association :user, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
