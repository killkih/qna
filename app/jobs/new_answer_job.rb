# frozen_string_literal: true

class NewAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    NewAnswerService.new.send_notice(answer)
  end
end
