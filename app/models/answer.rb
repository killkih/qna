# frozen_string_literal: true

class Answer < ApplicationRecord
  include HasLink
  include HasAttachedFiles
  include HasVote

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
    transaction do
      self.class.where(question_id: question_id).update_all(best: false)
      update(best: true)
    end
  end
end
