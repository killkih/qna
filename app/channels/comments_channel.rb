# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments_channel_#{params[:question_id]}" if params[:question_id].present?
  end
end
