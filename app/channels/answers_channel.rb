# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "answers_channel_#{params[:question_id]}" if params[:question_id].present?
  end
end
