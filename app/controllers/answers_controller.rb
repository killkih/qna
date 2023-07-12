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

    if current_user.id == answer.user_id
      answer.destroy
      redirect_to question_path(@question), notice: 'Answer successfully deleted!'
    else
      redirect_to question_path(@question), notice: 'Only the author can delete a answer!'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer
end
