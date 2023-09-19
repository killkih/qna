# frozen_string_literal: true

class DailyDigestService

  def send_digest
    if have_questions?
      User.find_each(batch_size: 500) do |user|
        DailyDigestMailer.digest(user).deliver_later
      end
    end
  end

  private

  def have_questions?
    Question.where(created_at: Time.now - 24.hours..Time.now).present?
  end
end
