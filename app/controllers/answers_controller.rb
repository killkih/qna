class AnswersController < ApplicationController
  expose :question
  expose :answer

  def create
    @ex_answer = question.answers.new(answer_params)

    if @ex_answer.save
      redirect_to @ex_answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
