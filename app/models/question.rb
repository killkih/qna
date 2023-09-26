# frozen_string_literal: true

class Question < ApplicationRecord
  include PgSearch
  include HasLink
  include HasAttachedFiles
  include HasVote
  include HasComment

  pg_search_scope :search_everywhere, against: [:title, :body]

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation
  after_create :subscribe!

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe!
    user.subscriptions.create(question: self)
  end
end
