# frozen_string_literal: true

class Question < ApplicationRecord
  include HasLink
  include HasAttachedFiles
  include HasVote

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true
end
