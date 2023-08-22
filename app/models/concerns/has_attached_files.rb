# frozen_string_literal: true

module HasAttachedFiles
  extend ActiveSupport::Concern

  included { has_many_attached :files }
end
