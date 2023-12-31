# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @question = answer.question
    answer.destroy
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  def mark_as_best
    answer.mark_as_best
    @question = answer.question
    set_reward if @question.reward
  end

  def purge
    @question = answer.question
    file = answer.files.find(params[:file])
    file.purge
  end

  private

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast("answers_channel_#{answer.question.id}", answer)
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def set_reward
    reward = @question.reward
    reward.user = answer.user
    reward.save
  end

  helper_method :answer
end
