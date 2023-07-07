class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question
  expose :answer

  def create
    @ex_answer = question.answers.new(answer_params)

    if @ex_answer.save
      redirect_to question_path(question), notice: 'Answer added successfully!'
    else
      redirect_to question_path(question), notice: 'Error adding answer'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
