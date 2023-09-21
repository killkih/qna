# frozen_string_literal: true

class DailyDigestService
  def send_digest
    return unless have_questions?

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end

  private

  def have_questions?
    Question.where(created_at: Time.now - 24.hours..Time.now).present?
  end
end
