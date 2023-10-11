# frozen_string_literal: true

class Comment < ApplicationRecord
  include HasSearch

  multisearchable against: :body
  pg_search_scope :search, against: :body

  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true

end
