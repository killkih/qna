# frozen_string_literal: true

class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    DailyDigestService.new.send_digest
  end
end
