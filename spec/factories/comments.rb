# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'MyString' }
    association :user, factory: :user
  end
end
