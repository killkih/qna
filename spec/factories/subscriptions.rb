# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    association :question, factory: :question
    association :user, factory: :user
  end
end
