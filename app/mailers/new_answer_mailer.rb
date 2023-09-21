# frozen_string_literal: true

class NewAnswerMailer < ApplicationMailer
  def notice(user, answer)
    @answer = answer
    @question = @answer.question

    mail to: user.email
  end
end
