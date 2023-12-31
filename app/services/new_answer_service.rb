# frozen_string_literal: true

class NewAnswerService
  def send_notice(answer)
    answer.question.subscriptions.each do |subscription|
      NewAnswerMailer.notice(subscription.user, answer).deliver_later
    end
  end
end
