# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

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
  end

  def purge
    @question = answer.question
    file = answer.files.find(params[:file])
    file.purge
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  helper_method :answer
end
