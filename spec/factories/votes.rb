# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    status { true }
    association :user, factory: :user
    association :votable, polymorphic: true
  end
end
