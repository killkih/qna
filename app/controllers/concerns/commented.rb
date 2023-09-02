# frozen_string_literal: true

module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[add_comment]
    after_action :publish_comment, only: %i[add_comment]
    authorize_resource
  end

  def add_comment
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?

    case @commentable
    when Answer
      ActionCable.server.broadcast("comments_channel_#{@commentable.question.id}", @comment)
    when Question
      ActionCable.server.broadcast("comments_channel_#{@commentable.id}", @comment)
    end
  end

  def comment_params
    params.permit(:body)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end
