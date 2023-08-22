# frozen_string_literal: true

module HasComment
  extend ActiveSupport::Concern

  included { has_many :comments, dependent: :destroy, as: :commentable }
end
