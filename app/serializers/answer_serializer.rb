# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :best, :user_id, :created_at, :updated_at, :urls
  has_many :comments
  has_many :links

  def urls
    object.files.map { |file| { url: rails_blob_url(file, only_path: true) } }
  end
end
