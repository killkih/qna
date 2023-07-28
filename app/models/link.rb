# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def gist?
    url.include?('https://gist.github.com/')
  end

  def gist_id
    url.split('/').last
  end
end
