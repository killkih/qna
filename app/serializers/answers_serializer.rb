class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :user_id, :created_at, :updated_at
end
