FactoryBot.define do
  factory :reward do
    title { 'MyTitle' }
    association :question, factory: :question
    association :user, factory: :user
    
  end
end
